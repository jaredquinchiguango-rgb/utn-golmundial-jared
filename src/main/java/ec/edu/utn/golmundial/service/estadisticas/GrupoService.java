package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import ec.edu.utn.golmundial.dto.estadisticas.GrupoDTO;
import ec.edu.utn.golmundial.util.ApiConfig;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@ApplicationScoped
public class GrupoService {

    private static final Logger LOG = Logger.getLogger(GrupoService.class.getName());

    private Client       client;
    private ObjectMapper mapper;

    @PostConstruct
    public void init() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
    }

    @PreDestroy
    public void destroy() {
        if (client != null) client.close();
    }

    public List<GrupoDTO> listarTodos() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/grupos")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<GrupoDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar grupos", e);
            return new ArrayList<>();
        }
    }

    /** GET /grupos/{id}/posiciones (RF05) - ya viene ordenado por el backend. */
    public GrupoDTO obtenerPosiciones(Integer idGrupo) {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/grupos/" + idGrupo + "/posiciones")
                .request(MediaType.APPLICATION_JSON)
                .get();

            if (response.getStatus() == 404) return null;

            String json = response.readEntity(String.class);
            return mapper.readValue(json, GrupoDTO.class);

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al obtener posiciones del grupo id=" + idGrupo, e);
            return null;
        }
    }
}
