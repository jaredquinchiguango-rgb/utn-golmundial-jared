package ec.edu.utn.golmundial.util;

/**
 * URLs base de las dos APIs REST que consume este frontend administrativo.
 *
 * IMPORTANTE:
 * - Mientras desarrollan en local, apunten a localhost con el puerto real
 *   donde cada backend está corriendo en SU maquina (Ariel / Puma).
 * - Cuando desplieguen en Render, reemplacen estos valores por las URLs
 *   publicas (https://xxxx.onrender.com/api).
 * - Idealmente esto se saca a una variable de entorno o a un
 *   resources/config.properties para no tener que recompilar cada vez
 *   que cambie la URL. Lo dejamos simple por ahora; lo mejoramos despues.
 */
public class ApiConfig {

    // Backend de Ariel: Jakarta EE - selecciones, grupos, sedes, partidos,
    // fases, usuarios, roles, auditoria.
    public static final String BASE_URL_ESTADISTICAS =
            "http://localhost:8080/api-estadisticas/api";

    // Backend de Puma: .NET - billeteras, transacciones, predicciones,
    // bono diario, configuracion del sistema.
    public static final String BASE_URL_UTNCOIN =
            "http://localhost:5000/api";

    private ApiConfig() {}
}
