package ec.edu.utn.golmundial.service.utncoin;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import ec.edu.utn.golmundial.dto.utncoin.BilleteraDTO;
import ec.edu.utn.golmundial.util.ApiConfig;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
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

    // TODO: confirmar con Puma el path real. Puede que el .NET ya exponga
    // un endpoint de reporte tipo /billeteras/total-circulante en vez de
    // tener que traer todas y sumar aqui.
    public List<BilleteraDTO> listarTodas() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_UTNCOIN + "/billeteras")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<BilleteraDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar billeteras", e);
            return new ArrayList<>();
        }
    }

    public BigDecimal calcularTotalCirculante() {
        return listarTodas().stream()
                .map(BilleteraDTO::getSaldo)
                .filter(java.util.Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
