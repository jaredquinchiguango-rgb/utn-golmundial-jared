package ec.edu.utn.golmundial.service.utncoin;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import ec.edu.utn.golmundial.dto.utncoin.ReportePrediccionDTO;
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
        mapper = new ObjectMapper();
    }

    @PreDestroy
    public void destroy() {
        if (client != null) client.close();
    }

    /**
     * GET /api/Predictions/report/most-predicted (confirmado por Puma).
     * Ya viene ordenado de mayor a menor - no hace falta ordenar aqui.
     */
    public List<ReportePrediccionDTO> obtenerReporteMasPredichos() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_UTNCOIN + "/api/Predictions/report/most-predicted")
                .request(MediaType.APPLICATION_JSON)
                .get();

            if (response.getStatus() != 200) {
                LOG.warning("GET /Predictions/report/most-predicted devolvio status " + response.getStatus());
                return new ArrayList<>();
            }

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<ReportePrediccionDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al obtener reporte de predicciones", e);
            return new ArrayList<>();
        }
    }
}
