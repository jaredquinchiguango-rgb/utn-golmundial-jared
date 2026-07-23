package ec.edu.utn.golmundial.util;

public class ApiConfig {

    // Backend de Ariel (Jakarta EE) - confirmado
    public static final String BASE_URL_ESTADISTICAS =
             //      "http://localhost:8080/estadisticas-backend/api";
        // Pa la U  "http://192.168.51.131:8080/estadisticas-backend/api";
                    "http://192.168.3.83:8080/estadisticas-backend/api";

    // Backend de Puma (.NET) - confirmado. Se usa HTTP (no HTTPS) para
    // evitar problemas de certificado autofirmado en desarrollo local.
    // Cuando este en Render, cambiar por la URL publica (siempre https).
    public static final String BASE_URL_UTNCOIN =
            "http://192.168.51.41:57782/api";

    private ApiConfig() {}
}
