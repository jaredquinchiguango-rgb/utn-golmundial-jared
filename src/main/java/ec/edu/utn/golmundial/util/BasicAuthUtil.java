package ec.edu.utn.golmundial.util;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * El AuthorizationFilter del backend de Ariel exige Basic Auth de un
 * ADMINISTRADOR para CUALQUIER escritura (POST/PUT) - no solo para el
 * endpoint de usuarios. Esta clase arma ese header en un solo lugar
 * para no repetir la logica en cada Service.
 */
public class BasicAuthUtil {

    public static String buildHeader(String email, String password) {
        String credenciales = email + ":" + password;
        return "Basic " + Base64.getEncoder().encodeToString(credenciales.getBytes(StandardCharsets.UTF_8));
    }

    private BasicAuthUtil() {}
}
