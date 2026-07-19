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
import java.util.ArrayList;
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

    // TODO: confirmar path con Ariel (ej: /usuarios)
    public List<UsuarioDTO> listarTodos() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/usuarios")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<UsuarioDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar usuarios", e);
            return new ArrayList<>();
        }
    }

    // Habilitar / deshabilitar una cuenta (RF23)
    public boolean cambiarEstado(Integer idUsuario, boolean nuevoEstado) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("estado", nuevoEstado);

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/usuarios/" + idUsuario + "/estado")
                .request(MediaType.APPLICATION_JSON)
                .put(Entity.json(mapper.writeValueAsString(body)));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al cambiar estado del usuario id=" + idUsuario, e);
            return false;
        }
    }

    /**
     * Login contra el Servicio de Estadisticas (RF02).
     * Endpoint y estructura CONFIRMADOS por Ariel:
     *   POST {BASE_URL_ESTADISTICAS}/login
     *   body:     {"email": "...", "password": "..."}
     *   response: {"idUser":1,"name":"...","email":"...","username":"...",
     *              "active":true,"role":"ADMINISTRADOR","idRole":1}
     * El mapeo ingles->espanol de la respuesta lo resuelve UsuarioDTO
     * con @JsonProperty, no hace falta tocar nada aqui.
     */
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
