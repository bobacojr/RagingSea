uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;
uniform float uColorOffset;
uniform float uColorMultiplier;

uniform vec3 uLightPosition;
uniform vec3 uLightColor;
uniform vec3 uAmbientLight;
uniform float uShininess;
uniform float uLightIntensity; // KM: Controls light brightness
uniform vec3 uCameraPosition;

varying float vElevation;
varying vec3 vNormal;
varying vec3 vWorldPosition;

void main() {
    // Base color from elevation
    float mixStrength = (vElevation + uColorOffset) * uColorMultiplier;
    vec3 baseColor = mix(uDepthColor, uSurfaceColor, mixStrength);

    // Phong lighting calculations
    vec3 normal = normalize(vNormal);
    vec3 lightDir = normalize(uLightPosition - vWorldPosition);
    vec3 viewDir = normalize(uCameraPosition - vWorldPosition);
    vec3 reflectDir = reflect(-lightDir, normal);

    // Ambient
    vec3 ambient = uAmbientLight * baseColor;

    // Diffuse (scaled by light intensity)
    float diff = max(dot(normal, lightDir), 0.0);
    vec3 diffuse = diff * uLightColor * baseColor * uLightIntensity;

    // Specular (highlights)
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), uShininess);
    vec3 specular = spec * uLightColor * uLightIntensity;

    // Combine all components
    vec3 finalColor = ambient + diffuse + specular;

    gl_FragColor = vec4(finalColor, 1.0);

}