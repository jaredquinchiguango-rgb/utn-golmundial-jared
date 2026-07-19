package ec.edu.utn.golmundial.service.utncoin;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import ec.edu.utn.golmundial.dto.utncoin.PrediccionDTO;
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
public class PrediccionService {

    private static final Logger LOG = Logger.getLogger(PrediccionService.class.getName());

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

    // TODO: confirmar path con Puma (ej: /predicciones)
    public List<PrediccionDTO> listarTodas() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_UTNCOIN + "/predicciones")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<PrediccionDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar predicciones", e);
            return new ArrayList<>();
        }
    }
}
