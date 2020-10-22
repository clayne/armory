// http://sebastien.hillaire.free.fr/index.php?option=com_content&view=article&id=72&Itemid=106
#version 450

#include "compiled.inc"
#include "std/gbuffer.glsl"
#include "std/shadows.glsl"
#ifdef _Clusters
#include "std/clusters.glsl"
#endif

uniform sampler2D gbufferD;
uniform sampler2D snoise;

#ifdef _Clusters
uniform vec4 lightsArray[maxLights * 2];
	#ifdef _Spot
	uniform vec4 lightsArraySpot[maxLights];
	#endif
uniform sampler2D clustersData;
uniform vec2 cameraPlane;
#endif

#ifdef _ShadowMap
#ifdef _SinglePoint
	#ifdef _Spot
	uniform sampler2DShadow shadowMapSpot[1];
	uniform mat4 LWVPSpot0;
	#else
	uniform samplerCubeShadow shadowMapPoint[1];
	uniform vec2 lightProj;
	#endif
#endif
#ifdef _Clusters
	uniform samplerCubeShadow shadowMapPoint[4];
	uniform vec2 lightProj;
	#ifdef _Spot
	uniform sampler2DShadow shadowMapSpot[4];
	uniform mat4 LWVPSpot0;
	uniform mat4 LWVPSpot1;
	uniform mat4 LWVPSpot2;
	uniform mat4 LWVPSpot3;
	#endif
#endif
#endif

#ifdef _Sun
uniform vec3 sunDir;
uniform vec3 sunCol;
	#ifdef _ShadowMap
	uniform sampler2DShadow shadowMap;
	uniform float shadowsBias;
	#ifdef _CSM
	//!uniform vec4 casData[shadowmapCascades * 4 + 4];
	#else
	uniform mat4 LWVP;
	#endif
	#endif // _ShadowMap
#endif

#ifdef _SinglePoint // Fast path for single light
uniform vec3 pointPos;
uniform vec3 pointCol;
	#ifdef _ShadowMap
	uniform float pointBias;
	#endif
	#ifdef _Spot
	uniform vec3 spotDir;
	uniform vec2 spotData;
	#endif
#endif

uniform vec2 cameraProj;
uniform vec3 eye;
uniform vec3 eyeLook;

in vec2 texCoord;
in vec3 viewRay;
out float fragColor;

const float tScat = 0.08;
const float tAbs = 0.0;
const float tExt = tScat + tAbs;
const float stepLen = 1.0 / volumSteps;
const float lighting = 0.4;

void rayStep(inout vec3 curPos, inout float curOpticalDepth, inout float scatteredLightAmount, float stepLenWorld, vec3 viewVecNorm) {
	curPos += stepLenWorld * viewVecNorm;
	const float density = 1.0;

	float l1 = lighting * stepLenWorld * tScat * density;
	curOpticalDepth *= exp(-tExt * stepLenWorld * density);

	float visibility = 0.0;

#ifdef _Sun
	#ifdef _CSM
	mat4 LWVP = mat4(casData[4], casData[4 + 1], casData[4 + 2], casData[4 + 3]);
	#endif
	vec4 lPos = LWVP * vec4(curPos, 1.0);
	lPos.xyz /= lPos.w;
	visibility = texture(shadowMap, vec3(lPos.xy, lPos.z - shadowsBias));
#endif

#ifdef _SinglePoint
	#ifdef _Spot
	vec4 lPos = LWVPSpot0 * vec4(curPos, 1.0);
	visibility = shadowTest(shadowMapSpot[0], lPos.xyz / lPos.w, pointBias);
	float spotEffect = dot(spotDir, normalize(pointPos - curPos)); // lightDir
	if (spotEffect < spotData.x) { // x - cutoff, y - cutoff - exponent
		visibility *= smoothstep(spotData.y, spotData.x, spotEffect);
	}
	#else
	vec3 ld = pointPos - curPos;
	visibility = PCFCube(shadowMapPoint[0], ld, -normalize(ld), pointBias, lightProj, vec3(0.0));
	#endif
#endif

#ifdef _Clusters
#endif

	scatteredLightAmount += curOpticalDepth * l1 * visibility;
}

void main() {
	float pixelRayMarchNoise = textureLod(snoise, texCoord * 100, 0.0).r * 2.0 - 1.0;

	float depth = textureLod(gbufferD, texCoord, 0.0).r * 2.0 - 1.0;
	vec3 p = getPos(eye, eyeLook, normalize(viewRay), depth, cameraProj);

	vec3 viewVec = p - eye;
	float worldPosDist = length(viewVec);
	vec3 viewVecNorm = viewVec / worldPosDist;

	float startDepth = 0.1;
	startDepth = min(worldPosDist, startDepth);
	float endDepth = 20.0;
	endDepth = min(worldPosDist, endDepth);

	vec3 curPos = eye + viewVecNorm * startDepth;
	float stepLenWorld = stepLen * (endDepth - startDepth);
	float curOpticalDepth = exp(-tExt * stepLenWorld);
	float scatteredLightAmount = 0.0;

	curPos += stepLenWorld * viewVecNorm * pixelRayMarchNoise;

	for (float l = stepLen; l < 0.99999; l += stepLen) { // Do not do the first and last steps
		rayStep(curPos, curOpticalDepth, scatteredLightAmount, stepLenWorld, viewVecNorm);
	}

	fragColor = scatteredLightAmount * volumAirTurbidity;
}
