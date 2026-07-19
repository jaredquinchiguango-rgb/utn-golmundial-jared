package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import ec.edu.utn.golmundial.dto.estadisticas.SedeDTO;
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
public class SedeService {

    private static final Logger LOG = Logger.getLogger(SedeService.class.getName());

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

    // TODO: confirmar path con Ariel (ej: /sedes)
    public List<SedeDTO> listarTodas() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/sedes")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<SedeDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar sedes", e);
            return new ArrayList<>();
        }
    }
}
