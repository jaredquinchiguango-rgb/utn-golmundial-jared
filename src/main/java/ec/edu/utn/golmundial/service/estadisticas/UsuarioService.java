package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import ec.edu.utn.golmundial.dto.estadisticas.UsuarioDTO;
import ec.edu.utn.golmundial.util.ApiConfig;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@ApplicationScoped
public class UsuarioService {

    private static final Logger LOG = Logger.getLogger(UsuarioService.class.getName());

    private Client       client;
    private ObjectMapper mapper;

    @PostConstruct
    public void init() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper().registerModule(new JavaTimeModule());
    }

    @PreDestroy
    public void destroy() {
        if (client != null) client.close();
    }

    private String basicAuthHeader(String email, String password) {
        String credenciales = email + ":" + password;
        return "Basic " + Base64.getEncoder().encodeToString(credenciales.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * GET /api/usuarios EXIGE Basic Auth con rol ADMINISTRADOR (confirmado
     * por Ariel). Recibe el email/password del admin ya logueado, que
     * LoginBean conserva durante la sesion para este proposito.
     */
    public List<UsuarioDTO> listarTodos(String emailAdmin, String passwordAdmin) {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/usuarios")
                .request(MediaType.APPLICATION_JSON)
                .header("Authorization", basicAuthHeader(emailAdmin, passwordAdmin))
                .get();

            if (response.getStatus() != 200) {
                LOG.warning("GET /usuarios devolvio status " + response.getStatus());
                return new ArrayList<>();
            }

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<UsuarioDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar usuarios", e);
            return new ArrayList<>();
        }
    }

    /** PUT /api/usuarios/{id} con {"active": true/false} (RF23, confirmado). */
    public boolean cambiarEstado(Integer idUsuario, boolean nuevoEstado,
                                  String emailAdmin, String passwordAdmin) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("active", nuevoEstado);

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/usuarios/" + idUsuario)
                .request(MediaType.APPLICATION_JSON)
                .header("Authorization", basicAuthHeader(emailAdmin, passwordAdmin))
                .put(Entity.json(mapper.writeValueAsString(body)));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al cambiar estado del usuario id=" + idUsuario, e);
            return false;
        }
    }

    /** POST /api/login (confirmado). No exige Basic Auth, es el login mismo. */
    public UsuarioDTO login(String email, String password) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("email", email);
            body.put("password", password);

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/login")
                .request(MediaType.APPLICATION_JSON)
                .post(Entity.json(mapper.writeValueAsString(body)));

            if (response.getStatus() != 200) {
                return null;
            }

            String json = response.readEntity(String.class);
            return mapper.readValue(json, UsuarioDTO.class);

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al iniciar sesion", e);
            return null;
        }
    }
}
