package ec.edu.utn.golmundial.service.utncoin;

import com.fasterxml.jackson.databind.ObjectMapper;
import ec.edu.utn.golmundial.dto.utncoin.TotalCirculacionDTO;
import ec.edu.utn.golmundial.util.ApiConfig;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;

@ApplicationScoped
public class BilleteraService {

    private static final Logger LOG = Logger.getLogger(BilleteraService.class.getName());

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

    /** GET /api/Wallets/total-circulation (confirmado por Puma). */
    public BigDecimal obtenerTotalCirculante() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_UTNCOIN + "/api/Wallets/total-circulation")
                .request(MediaType.APPLICATION_JSON)
                .get();

            if (response.getStatus() != 200) {
                LOG.warning("GET /Wallets/total-circulation devolvio status " + response.getStatus());
                return BigDecimal.ZERO;
            }

            String json = response.readEntity(String.class);
            TotalCirculacionDTO dto = mapper.readValue(json, TotalCirculacionDTO.class);
            return dto.getTotalCirculante() != null ? dto.getTotalCirculante() : BigDecimal.ZERO;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al obtener total circulante", e);
            return BigDecimal.ZERO;
        }
    }
}
