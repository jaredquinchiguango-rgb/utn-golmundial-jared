#!/usr/bin/env bash
# =============================================================================
# setup-frontend-admin.sh
# Crea la estructura inicial del proyecto frontend-admin (Frontend Administrativo JSF)
# UTN GolMundial 2026 - Proyecto Integrador
#
# Uso: ejecutar desde la raiz del proyecto generado por maven-archetype-webapp
#      cd $HOME/ProyectosUTN/frontend-admin
#      bash setup-frontend-admin.sh
# =============================================================================

set -e

echo "=== Creando estructura de directorios ==="
mkdir -p src/main/java/ec/edu/utn/golmundial/{bean,util,security}
mkdir -p src/main/java/ec/edu/utn/golmundial/dto/{estadisticas,utncoin}
mkdir -p src/main/java/ec/edu/utn/golmundial/service/{estadisticas,utncoin}
mkdir -p src/main/webapp/WEB-INF/templates
mkdir -p src/main/webapp/resources/css
mkdir -p src/main/webapp/{partidos,usuarios,selecciones,reportes}
echo "OK"

# =============================================================================
# pom.xml
# =============================================================================
echo "=== Reemplazando pom.xml ==="

cat > pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>ec.edu.utn.golmundial</groupId>
    <artifactId>frontend-admin</artifactId>
    <version>1.0.0</version>
    <packaging>war</packaging>
    <name>UTN GolMundial 2026 - Frontend Administrativo</name>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <failOnMissingWebXml>false</failOnMissingWebXml>
    </properties>

    <dependencies>
        <!-- Jakarta EE 10 provisto por WildFly -->
        <dependency>
            <groupId>jakarta.platform</groupId>
            <artifactId>jakarta.jakartaee-api</artifactId>
            <version>10.0.0</version>
            <scope>provided</scope>
        </dependency>

        <!-- Jackson para deserializar JSON de las dos APIs REST -->
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>2.15.2</version>
        </dependency>
        <!-- Soporte para LocalDate / LocalDateTime en Jackson -->
        <dependency>
            <groupId>com.fasterxml.jackson.datatype</groupId>
            <artifactId>jackson-datatype-jsr310</artifactId>
            <version>2.15.2</version>
        </dependency>
    </dependencies>

    <build>
        <finalName>frontend-admin</finalName>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.4.0</version>
            </plugin>
        </plugins>
    </build>
</project>
EOF
echo "OK"

# =============================================================================
# web.xml / faces-config.xml
# =============================================================================
echo "=== Creando archivos de configuracion ==="

cat > src/main/webapp/WEB-INF/web.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">

    <context-param>
        <param-name>jakarta.faces.PROJECT_STAGE</param-name>
        <param-value>Development</param-value>
    </context-param>

    <context-param>
        <param-name>jakarta.faces.FACELETS_SKIP_COMMENTS</param-name>
        <param-value>true</param-value>
    </context-param>

    <servlet>
        <servlet-name>Faces Servlet</servlet-name>
        <servlet-class>jakarta.faces.webapp.FacesServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>Faces Servlet</servlet-name>
        <url-pattern>*.xhtml</url-pattern>
    </servlet-mapping>

    <welcome-file-list>
        <welcome-file>index.xhtml</welcome-file>
    </welcome-file-list>

</web-app>
EOF

# faces-config.xml se queda simple por ahora. En el paso de "Login y control de
# acceso" (siguiente paso que hagamos) le agregaremos <lifecycle> con el
# AccesoPhaseListener, igual que en el tutorial 04c.
cat > src/main/webapp/WEB-INF/faces-config.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<faces-config xmlns="https://jakarta.ee/xml/ns/jakartaee"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
              https://jakarta.ee/xml/ns/jakartaee/web-facesconfig_4_0.xsd"
              version="4.0">
</faces-config>
EOF
echo "OK"

# =============================================================================
# util: ApiConfig (LAS DOS BASE_URL - AQUI CONECTAS CON TUS COMPAÑEROS)
# =============================================================================
echo "=== Creando ApiConfig ==="

cat > src/main/java/ec/edu/utn/golmundial/util/ApiConfig.java << 'EOF'
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
EOF
echo "OK"

# =============================================================================
# DTOs - dominio Estadisticas (basados en el diagrama de clases de Ariel)
# =============================================================================
echo "=== Creando DTOs de Estadisticas ==="

cat > src/main/java/ec/edu/utn/golmundial/dto/estadisticas/UsuarioDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.estadisticas;

import java.time.LocalDateTime;

public class UsuarioDTO {

    private Integer idUsuario;
    private String  nombre;
    private String  email;
    private String  username;
    private Boolean estado;
    private LocalDateTime fechaRegistro;
    private LocalDateTime ultimoAcceso;
    private Integer idRol;
    private String  nombreRol;

    public UsuarioDTO() {}

    public Integer getIdUsuario()                  { return idUsuario; }
    public void    setIdUsuario(Integer v)         { this.idUsuario = v; }

    public String  getNombre()                     { return nombre; }
    public void    setNombre(String v)              { this.nombre = v; }

    public String  getEmail()                       { return email; }
    public void    setEmail(String v)                { this.email = v; }

    public String  getUsername()                    { return username; }
    public void    setUsername(String v)             { this.username = v; }

    public Boolean getEstado()                       { return estado; }
    public void    setEstado(Boolean v)              { this.estado = v; }

    public LocalDateTime getFechaRegistro()          { return fechaRegistro; }
    public void    setFechaRegistro(LocalDateTime v) { this.fechaRegistro = v; }

    public LocalDateTime getUltimoAcceso()           { return ultimoAcceso; }
    public void    setUltimoAcceso(LocalDateTime v)  { this.ultimoAcceso = v; }

    public Integer getIdRol()                        { return idRol; }
    public void    setIdRol(Integer v)                { this.idRol = v; }

    public String  getNombreRol()                    { return nombreRol; }
    public void    setNombreRol(String v)             { this.nombreRol = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/dto/estadisticas/RolDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.estadisticas;

public class RolDTO {

    private Integer idRol;
    private String  nombre;
    private String  descripcion;

    public RolDTO() {}

    public Integer getIdRol()               { return idRol; }
    public void    setIdRol(Integer v)      { this.idRol = v; }

    public String  getNombre()              { return nombre; }
    public void    setNombre(String v)      { this.nombre = v; }

    public String  getDescripcion()         { return descripcion; }
    public void    setDescripcion(String v) { this.descripcion = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/dto/estadisticas/SeleccionDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.estadisticas;

public class SeleccionDTO {

    private Integer idSeleccion;
    private String  nombre;
    private String  codigoFifa;
    private Boolean esAnfitrion;
    private String  clasificacion;
    private Integer partidosJugados;
    private Integer puntos;
    private Integer partidosGanados;
    private Integer partidosEmpatados;
    private Integer partidosPerdidos;
    private Integer golesFavor;
    private Integer golesContra;
    private Integer idGrupo;
    private String  nombreGrupo;

    public SeleccionDTO() {}

    public Integer getIdSeleccion()                 { return idSeleccion; }
    public void    setIdSeleccion(Integer v)        { this.idSeleccion = v; }

    public String  getNombre()                       { return nombre; }
    public void    setNombre(String v)               { this.nombre = v; }

    public String  getCodigoFifa()                   { return codigoFifa; }
    public void    setCodigoFifa(String v)           { this.codigoFifa = v; }

    public Boolean getEsAnfitrion()                  { return esAnfitrion; }
    public void    setEsAnfitrion(Boolean v)         { this.esAnfitrion = v; }

    public String  getClasificacion()                { return clasificacion; }
    public void    setClasificacion(String v)        { this.clasificacion = v; }

    public Integer getPartidosJugados()              { return partidosJugados; }
    public void    setPartidosJugados(Integer v)     { this.partidosJugados = v; }

    public Integer getPuntos()                        { return puntos; }
    public void    setPuntos(Integer v)                { this.puntos = v; }

    public Integer getPartidosGanados()               { return partidosGanados; }
    public void    setPartidosGanados(Integer v)      { this.partidosGanados = v; }

    public Integer getPartidosEmpatados()             { return partidosEmpatados; }
    public void    setPartidosEmpatados(Integer v)    { this.partidosEmpatados = v; }

    public Integer getPartidosPerdidos()              { return partidosPerdidos; }
    public void    setPartidosPerdidos(Integer v)     { this.partidosPerdidos = v; }

    public Integer getGolesFavor()                    { return golesFavor; }
    public void    setGolesFavor(Integer v)            { this.golesFavor = v; }

    public Integer getGolesContra()                   { return golesContra; }
    public void    setGolesContra(Integer v)           { this.golesContra = v; }

    public Integer getIdGrupo()                        { return idGrupo; }
    public void    setIdGrupo(Integer v)               { this.idGrupo = v; }

    public String  getNombreGrupo()                    { return nombreGrupo; }
    public void    setNombreGrupo(String v)            { this.nombreGrupo = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/dto/estadisticas/GrupoDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.estadisticas;

public class GrupoDTO {

    private Integer idGrupo;
    private String  codigo;
    private String  nombre;

    public GrupoDTO() {}

    public Integer getIdGrupo()             { return idGrupo; }
    public void    setIdGrupo(Integer v)    { this.idGrupo = v; }

    public String  getCodigo()              { return codigo; }
    public void    setCodigo(String v)      { this.codigo = v; }

    public String  getNombre()              { return nombre; }
    public void    setNombre(String v)      { this.nombre = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/dto/estadisticas/SedeDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.estadisticas;

public class SedeDTO {

    private Integer idSede;
    private String  estadio;
    private Integer capacidad;
    private String  nombreCiudad;

    public SedeDTO() {}

    public Integer getIdSede()               { return idSede; }
    public void    setIdSede(Integer v)      { this.idSede = v; }

    public String  getEstadio()              { return estadio; }
    public void    setEstadio(String v)      { this.estadio = v; }

    public Integer getCapacidad()            { return capacidad; }
    public void    setCapacidad(Integer v)   { this.capacidad = v; }

    public String  getNombreCiudad()         { return nombreCiudad; }
    public void    setNombreCiudad(String v) { this.nombreCiudad = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/dto/estadisticas/FaseDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.estadisticas;

import java.time.LocalDate;

public class FaseDTO {

    private Integer  idFase;
    private String   nombre;
    private String   codigo;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;

    public FaseDTO() {}

    public Integer   getIdFase()                 { return idFase; }
    public void      setIdFase(Integer v)        { this.idFase = v; }

    public String    getNombre()                 { return nombre; }
    public void      setNombre(String v)         { this.nombre = v; }

    public String    getCodigo()                 { return codigo; }
    public void      setCodigo(String v)         { this.codigo = v; }

    public LocalDate getFechaInicio()            { return fechaInicio; }
    public void      setFechaInicio(LocalDate v) { this.fechaInicio = v; }

    public LocalDate getFechaFin()               { return fechaFin; }
    public void      setFechaFin(LocalDate v)    { this.fechaFin = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/dto/estadisticas/PartidoDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.estadisticas;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PartidoDTO {

    private Integer idPartido;
    private Integer numeroPartidoFifa;
    private LocalDateTime fechaHoraUtc;
    private String  estado;               // programado, en_juego, finalizado
    private Integer golesLocal;
    private Integer golesVisitante;
    private BigDecimal cuotaLocal;
    private BigDecimal cuotaEmpate;
    private BigDecimal cuotaVisitante;
    private LocalDateTime fechaResultadoRegistrado;

    // Relaciones aplanadas (igual que nombreCategoria en ProductoDTO)
    private Integer idSeleccionLocal;
    private String  nombreSeleccionLocal;
    private Integer idSeleccionVisitante;
    private String  nombreSeleccionVisitante;
    private Integer idSede;
    private String  nombreSede;
    private Integer idFase;
    private String  nombreFase;
    private Integer idGrupo;
    private String  nombreGrupo;

    public PartidoDTO() {}

    public Integer getIdPartido()                        { return idPartido; }
    public void    setIdPartido(Integer v)               { this.idPartido = v; }

    public Integer getNumeroPartidoFifa()                { return numeroPartidoFifa; }
    public void    setNumeroPartidoFifa(Integer v)       { this.numeroPartidoFifa = v; }

    public LocalDateTime getFechaHoraUtc()                { return fechaHoraUtc; }
    public void    setFechaHoraUtc(LocalDateTime v)       { this.fechaHoraUtc = v; }

    public String  getEstado()                            { return estado; }
    public void    setEstado(String v)                    { this.estado = v; }

    public Integer getGolesLocal()                        { return golesLocal; }
    public void    setGolesLocal(Integer v)               { this.golesLocal = v; }

    public Integer getGolesVisitante()                    { return golesVisitante; }
    public void    setGolesVisitante(Integer v)           { this.golesVisitante = v; }

    public BigDecimal getCuotaLocal()                     { return cuotaLocal; }
    public void    setCuotaLocal(BigDecimal v)            { this.cuotaLocal = v; }

    public BigDecimal getCuotaEmpate()                    { return cuotaEmpate; }
    public void    setCuotaEmpate(BigDecimal v)           { this.cuotaEmpate = v; }

    public BigDecimal getCuotaVisitante()                 { return cuotaVisitante; }
    public void    setCuotaVisitante(BigDecimal v)        { this.cuotaVisitante = v; }

    public LocalDateTime getFechaResultadoRegistrado()     { return fechaResultadoRegistrado; }
    public void    setFechaResultadoRegistrado(LocalDateTime v) { this.fechaResultadoRegistrado = v; }

    public Integer getIdSeleccionLocal()                  { return idSeleccionLocal; }
    public void    setIdSeleccionLocal(Integer v)         { this.idSeleccionLocal = v; }

    public String  getNombreSeleccionLocal()              { return nombreSeleccionLocal; }
    public void    setNombreSeleccionLocal(String v)      { this.nombreSeleccionLocal = v; }

    public Integer getIdSeleccionVisitante()              { return idSeleccionVisitante; }
    public void    setIdSeleccionVisitante(Integer v)     { this.idSeleccionVisitante = v; }

    public String  getNombreSeleccionVisitante()          { return nombreSeleccionVisitante; }
    public void    setNombreSeleccionVisitante(String v)  { this.nombreSeleccionVisitante = v; }

    public Integer getIdSede()                             { return idSede; }
    public void    setIdSede(Integer v)                    { this.idSede = v; }

    public String  getNombreSede()                         { return nombreSede; }
    public void    setNombreSede(String v)                 { this.nombreSede = v; }

    public Integer getIdFase()                             { return idFase; }
    public void    setIdFase(Integer v)                    { this.idFase = v; }

    public String  getNombreFase()                         { return nombreFase; }
    public void    setNombreFase(String v)                 { this.nombreFase = v; }

    public Integer getIdGrupo()                             { return idGrupo; }
    public void    setIdGrupo(Integer v)                    { this.idGrupo = v; }

    public String  getNombreGrupo()                         { return nombreGrupo; }
    public void    setNombreGrupo(String v)                 { this.nombreGrupo = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/dto/estadisticas/AuditoriaDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.estadisticas;

import java.time.LocalDateTime;

public class AuditoriaDTO {

    private Integer idAuditoria;
    private String  tipoAccion;
    private LocalDateTime fechaHora;
    private String  tablaAfectada;
    private String  descripcion;

    public AuditoriaDTO() {}

    public Integer getIdAuditoria()                { return idAuditoria; }
    public void    setIdAuditoria(Integer v)       { this.idAuditoria = v; }

    public String  getTipoAccion()                 { return tipoAccion; }
    public void    setTipoAccion(String v)         { this.tipoAccion = v; }

    public LocalDateTime getFechaHora()            { return fechaHora; }
    public void    setFechaHora(LocalDateTime v)   { this.fechaHora = v; }

    public String  getTablaAfectada()              { return tablaAfectada; }
    public void    setTablaAfectada(String v)      { this.tablaAfectada = v; }

    public String  getDescripcion()                { return descripcion; }
    public void    setDescripcion(String v)        { this.descripcion = v; }
}
EOF
echo "OK"

# =============================================================================
# DTOs - dominio UTNGolCoin (basados en el diagrama de clases de Puma)
# =============================================================================
echo "=== Creando DTOs de UTNGolCoin ==="

cat > src/main/java/ec/edu/utn/golmundial/dto/utncoin/BilleteraDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.utncoin;

import java.math.BigDecimal;

public class BilleteraDTO {

    private Integer    idBilletera;
    private Integer    idUsuario;
    private BigDecimal saldo;
    private Boolean    estado;

    public BilleteraDTO() {}

    public Integer    getIdBilletera()             { return idBilletera; }
    public void       setIdBilletera(Integer v)    { this.idBilletera = v; }

    public Integer    getIdUsuario()               { return idUsuario; }
    public void       setIdUsuario(Integer v)      { this.idUsuario = v; }

    public BigDecimal getSaldo()                   { return saldo; }
    public void       setSaldo(BigDecimal v)       { this.saldo = v; }

    public Boolean    getEstado()                  { return estado; }
    public void       setEstado(Boolean v)         { this.estado = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/dto/utncoin/TransaccionDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.utncoin;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class TransaccionDTO {

    private Integer       idTransaccion;
    private String        tipo;
    private BigDecimal    monto;
    private BigDecimal    saldoResultante;
    private LocalDateTime fecha;
    private String        descripcion;

    public TransaccionDTO() {}

    public Integer       getIdTransaccion()                 { return idTransaccion; }
    public void          setIdTransaccion(Integer v)        { this.idTransaccion = v; }

    public String         getTipo()                         { return tipo; }
    public void          setTipo(String v)                  { this.tipo = v; }

    public BigDecimal     getMonto()                        { return monto; }
    public void          setMonto(BigDecimal v)              { this.monto = v; }

    public BigDecimal     getSaldoResultante()               { return saldoResultante; }
    public void          setSaldoResultante(BigDecimal v)    { this.saldoResultante = v; }

    public LocalDateTime  getFecha()                         { return fecha; }
    public void          setFecha(LocalDateTime v)           { this.fecha = v; }

    public String         getDescripcion()                   { return descripcion; }
    public void          setDescripcion(String v)            { this.descripcion = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/dto/utncoin/PrediccionDTO.java << 'EOF'
package ec.edu.utn.golmundial.dto.utncoin;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PrediccionDTO {

    private Integer       idPrediccion;
    private Integer       idPartido;
    private String        resultadoPredicho; // L, E, V
    private BigDecimal    monto;
    private BigDecimal    cuotaAplicada;
    private BigDecimal    premio;
    private String        estado; // pendiente, ganada, perdida
    private LocalDateTime fechaCreacion;

    public PrediccionDTO() {}

    public Integer       getIdPrediccion()                { return idPrediccion; }
    public void          setIdPrediccion(Integer v)       { this.idPrediccion = v; }

    public Integer       getIdPartido()                   { return idPartido; }
    public void          setIdPartido(Integer v)          { this.idPartido = v; }

    public String         getResultadoPredicho()          { return resultadoPredicho; }
    public void          setResultadoPredicho(String v)   { this.resultadoPredicho = v; }

    public BigDecimal     getMonto()                      { return monto; }
    public void          setMonto(BigDecimal v)            { this.monto = v; }

    public BigDecimal     getCuotaAplicada()               { return cuotaAplicada; }
    public void          setCuotaAplicada(BigDecimal v)    { this.cuotaAplicada = v; }

    public BigDecimal     getPremio()                      { return premio; }
    public void          setPremio(BigDecimal v)            { this.premio = v; }

    public String         getEstado()                      { return estado; }
    public void          setEstado(String v)               { this.estado = v; }

    public LocalDateTime  getFechaCreacion()                { return fechaCreacion; }
    public void          setFechaCreacion(LocalDateTime v)  { this.fechaCreacion = v; }
}
EOF
echo "OK"

# =============================================================================
# Services - Estadisticas (PartidoService completo, resto en modo lista)
# =============================================================================
echo "=== Creando Services de Estadisticas ==="

cat > src/main/java/ec/edu/utn/golmundial/service/estadisticas/PartidoService.java << 'EOF'
package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import ec.edu.utn.golmundial.dto.estadisticas.PartidoDTO;
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
public class PartidoService {

    private static final Logger LOG = Logger.getLogger(PartidoService.class.getName());

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

    // TODO: confirmar con Ariel el path exacto del endpoint (ej: /partidos)
    public List<PartidoDTO> listarTodos() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<PartidoDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar partidos", e);
            return new ArrayList<>();
        }
    }

    public PartidoDTO buscarPorId(Integer id) {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos/" + id)
                .request(MediaType.APPLICATION_JSON)
                .get();

            if (response.getStatus() == 404) return null;

            String json = response.readEntity(String.class);
            return mapper.readValue(json, PartidoDTO.class);

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al buscar partido id=" + id, e);
            return null;
        }
    }

    public boolean crear(PartidoDTO dto) {
        try {
            String bodyJson = mapper.writeValueAsString(construirBodyCrear(dto));
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos")
                .request(MediaType.APPLICATION_JSON)
                .post(Entity.json(bodyJson));

            return response.getStatus() == 201;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al crear partido", e);
            return false;
        }
    }

    public boolean actualizar(PartidoDTO dto) {
        try {
            String bodyJson = mapper.writeValueAsString(construirBodyCrear(dto));
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos/" + dto.getIdPartido())
                .request(MediaType.APPLICATION_JSON)
                .put(Entity.json(bodyJson));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al actualizar partido id=" + dto.getIdPartido(), e);
            return false;
        }
    }

    /**
     * Registra el resultado oficial de un partido (RF11). Al hacerlo, el
     * Servicio de Estadisticas es quien internamente notifica al Servicio
     * UTNGolCoin para liquidar las predicciones (RF12) - nosotros solo
     * llamamos a este endpoint, la logica de liquidacion no es nuestra.
     *
     * TODO: confirmar con Ariel el path exacto (puede ser PUT /partidos/{id}/resultado
     * o similar) y el nombre real de los campos del body.
     */
    public boolean registrarResultado(Integer idPartido, Integer golesLocal, Integer golesVisitante) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("golesLocal", golesLocal);
            body.put("golesVisitante", golesVisitante);

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos/" + idPartido + "/resultado")
                .request(MediaType.APPLICATION_JSON)
                .put(Entity.json(mapper.writeValueAsString(body)));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al registrar resultado del partido id=" + idPartido, e);
            return false;
        }
    }

    private ObjectNode construirBodyCrear(PartidoDTO dto) {
        ObjectNode body = mapper.createObjectNode();
        body.put("numeroPartidoFifa", dto.getNumeroPartidoFifa());
        body.put("idSeleccionLocal", dto.getIdSeleccionLocal());
        body.put("idSeleccionVisitante", dto.getIdSeleccionVisitante());
        body.put("idSede", dto.getIdSede());
        body.put("idFase", dto.getIdFase());
        body.put("idGrupo", dto.getIdGrupo());
        return body;
    }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/service/estadisticas/SeleccionService.java << 'EOF'
package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
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
public class SeleccionService {

    private static final Logger LOG = Logger.getLogger(SeleccionService.class.getName());

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

    // TODO: confirmar path con Ariel (ej: /selecciones)
    public List<SeleccionDTO> listarTodas() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/selecciones")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<SeleccionDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar selecciones", e);
            return new ArrayList<>();
        }
    }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/service/estadisticas/SedeService.java << 'EOF'
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
EOF

cat > src/main/java/ec/edu/utn/golmundial/service/estadisticas/FaseService.java << 'EOF'
package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import ec.edu.utn.golmundial.dto.estadisticas.FaseDTO;
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
public class FaseService {

    private static final Logger LOG = Logger.getLogger(FaseService.class.getName());

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

    // TODO: confirmar path con Ariel (ej: /fases)
    public List<FaseDTO> listarTodas() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/fases")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<FaseDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar fases", e);
            return new ArrayList<>();
        }
    }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/service/estadisticas/GrupoService.java << 'EOF'
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

    // TODO: confirmar path con Ariel (ej: /grupos)
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
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/service/estadisticas/UsuarioService.java << 'EOF'
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
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/service/estadisticas/AuditoriaService.java << 'EOF'
package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import ec.edu.utn.golmundial.dto.estadisticas.AuditoriaDTO;
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
public class AuditoriaService {

    private static final Logger LOG = Logger.getLogger(AuditoriaService.class.getName());

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

    // TODO: confirmar path con Ariel (ej: /auditoria)
    public List<AuditoriaDTO> listarTodas() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/auditoria")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<AuditoriaDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar auditoria", e);
            return new ArrayList<>();
        }
    }
}
EOF
echo "OK"

# =============================================================================
# Services - UTNGolCoin (para los reportes: RF27)
# =============================================================================
echo "=== Creando Services de UTNGolCoin ==="

cat > src/main/java/ec/edu/utn/golmundial/service/utncoin/BilleteraService.java << 'EOF'
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
EOF

cat > src/main/java/ec/edu/utn/golmundial/service/utncoin/PrediccionService.java << 'EOF'
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
EOF
echo "OK"

# =============================================================================
# Beans
# =============================================================================
echo "=== Creando Beans ==="

cat > src/main/java/ec/edu/utn/golmundial/bean/PartidoBean.java << 'EOF'
package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.FaseDTO;
import ec.edu.utn.golmundial.dto.estadisticas.PartidoDTO;
import ec.edu.utn.golmundial.dto.estadisticas.SedeDTO;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
import ec.edu.utn.golmundial.service.estadisticas.FaseService;
import ec.edu.utn.golmundial.service.estadisticas.PartidoService;
import ec.edu.utn.golmundial.service.estadisticas.SedeService;
import ec.edu.utn.golmundial.service.estadisticas.SeleccionService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class PartidoBean implements Serializable {

    @Inject private PartidoService   partidoService;
    @Inject private SeleccionService seleccionService;
    @Inject private SedeService      sedeService;
    @Inject private FaseService      faseService;

    private List<PartidoDTO>   partidos;
    private List<SeleccionDTO> selecciones;
    private List<SedeDTO>      sedes;
    private List<FaseDTO>      fases;

    private PartidoDTO partidoSeleccionado;
    private Integer    golesLocalForm;
    private Integer    golesVisitanteForm;

    @PostConstruct
    public void init() {
        cargarPartidos();
        selecciones = seleccionService.listarTodas();
        sedes       = sedeService.listarTodas();
        fases       = faseService.listarTodas();
    }

    public void cargarPartidos() {
        partidos = partidoService.listarTodos();
    }

    public String prepararNuevo() {
        partidoSeleccionado = new PartidoDTO();
        return "/partidos/nuevo?faces-redirect=true";
    }

    public String guardarNuevo() {
        boolean exito = partidoService.crear(partidoSeleccionado);
        if (exito) {
            cargarPartidos();
            msg(FacesMessage.SEVERITY_INFO, "Partido creado correctamente.");
            return "/partidos/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo crear el partido. Verifique los datos.");
        return null;
    }

    public String prepararEditar(PartidoDTO partido) {
        partidoSeleccionado = partido;
        return "/partidos/editar?faces-redirect=true";
    }

    public String guardarEdicion() {
        boolean exito = partidoService.actualizar(partidoSeleccionado);
        if (exito) {
            cargarPartidos();
            msg(FacesMessage.SEVERITY_INFO, "Partido actualizado correctamente.");
            return "/partidos/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo actualizar el partido.");
        return null;
    }

    public String prepararResultado(PartidoDTO partido) {
        partidoSeleccionado = partido;
        golesLocalForm = partido.getGolesLocal();
        golesVisitanteForm = partido.getGolesVisitante();
        return "/partidos/resultado?faces-redirect=true";
    }

    public String guardarResultado() {
        boolean exito = partidoService.registrarResultado(
                partidoSeleccionado.getIdPartido(), golesLocalForm, golesVisitanteForm);
        if (exito) {
            cargarPartidos();
            msg(FacesMessage.SEVERITY_INFO,
                "Resultado registrado. Las predicciones se liquidan automaticamente.");
            return "/partidos/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo registrar el resultado.");
        return null;
    }

    public String cancelar() {
        partidoSeleccionado = null;
        return "/partidos/lista?faces-redirect=true";
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public List<PartidoDTO>   getPartidos()             { return partidos; }
    public List<SeleccionDTO> getSelecciones()          { return selecciones; }
    public List<SedeDTO>      getSedes()                { return sedes; }
    public List<FaseDTO>      getFases()                { return fases; }

    public PartidoDTO getPartidoSeleccionado()          { return partidoSeleccionado; }
    public void       setPartidoSeleccionado(PartidoDTO v) { this.partidoSeleccionado = v; }

    public Integer getGolesLocalForm()                  { return golesLocalForm; }
    public void    setGolesLocalForm(Integer v)         { this.golesLocalForm = v; }

    public Integer getGolesVisitanteForm()               { return golesVisitanteForm; }
    public void    setGolesVisitanteForm(Integer v)      { this.golesVisitanteForm = v; }
}
EOF

cat > src/main/java/ec/edu/utn/golmundial/bean/UsuarioBean.java << 'EOF'
package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.UsuarioDTO;
import ec.edu.utn.golmundial.service.estadisticas.UsuarioService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class UsuarioBean implements Serializable {

    @Inject private UsuarioService usuarioService;

    private List<UsuarioDTO> usuarios;

    @PostConstruct
    public void init() {
        cargarUsuarios();
    }

    public void cargarUsuarios() {
        usuarios = usuarioService.listarTodos();
    }

    public void cambiarEstado(UsuarioDTO usuario) {
        boolean nuevoEstado = !Boolean.TRUE.equals(usuario.getEstado());
        if (usuarioService.cambiarEstado(usuario.getIdUsuario(), nuevoEstado)) {
            cargarUsuarios();
            msg(FacesMessage.SEVERITY_INFO, "Estado del usuario actualizado.");
        } else {
            msg(FacesMessage.SEVERITY_ERROR, "No se pudo actualizar el estado del usuario.");
        }
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public List<UsuarioDTO> getUsuarios() { return usuarios; }
}
EOF
echo "OK"

# =============================================================================
# XHTML - layout sobrio tipo panel de control
# =============================================================================
echo "=== Creando layout.xhtml ==="

cat > src/main/webapp/WEB-INF/templates/layout.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:f="jakarta.faces.core"
      xmlns:ui="jakarta.faces.facelets">

<h:head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title><ui:insert name="titulo">GolMundial 2026 - Admin</ui:insert></title>
    <h:outputStylesheet library="css" name="estilos.css"/>
</h:head>

<h:body>

    <nav class="navbar">
        <div class="navbar-brand">
            <h:link outcome="/index" styleClass="brand-link">GolMundial 2026 · Panel Admin</h:link>
        </div>
        <ul class="navbar-menu">
            <li><h:link outcome="/index"              value="Inicio"      styleClass="nav-link"/></li>
            <li><h:link outcome="/partidos/lista"      value="Partidos"    styleClass="nav-link"/></li>
            <li><h:link outcome="/selecciones/lista"   value="Selecciones" styleClass="nav-link"/></li>
            <li><h:link outcome="/usuarios/lista"      value="Usuarios"    styleClass="nav-link"/></li>
            <li><h:link outcome="/reportes/lista"      value="Reportes"    styleClass="nav-link"/></li>
        </ul>
        <div class="navbar-user">
            <span class="user-placeholder">Administrador</span>
        </div>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <h1 class="page-title"><ui:insert name="cabecera">Inicio</ui:insert></h1>
            <div class="page-actions"><ui:insert name="acciones"/></div>
        </div>

        <h:messages globalOnly="true" styleClass="messages" errorClass="msg-error"
                    infoClass="msg-info" warnClass="msg-warn"/>

        <div class="page-body">
            <ui:insert name="contenido"><p>Sin contenido.</p></ui:insert>
        </div>
    </main>

    <footer class="footer">
        <p>UTN GolMundial 2026 - Panel Administrativo</p>
    </footer>

</h:body>
</html>
EOF

cat > src/main/webapp/index.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">GolMundial 2026 - Panel Administrativo</ui:define>
    <ui:define name="cabecera">Bienvenido</ui:define>

    <ui:define name="contenido">
        <div class="index-hero">
            <h2>Panel Administrativo del Mundial 2026</h2>
            <p>Selecciona una seccion para comenzar</p>
        </div>
        <div class="accesos-grid">
            <div class="acceso-card">
                <div class="icono">&#9917;</div>
                <h3>Partidos</h3>
                <p>Gestionar partidos y registrar resultados oficiales</p>
                <h:link outcome="/partidos/lista" styleClass="btn btn-primary mt-2">Ir a Partidos</h:link>
            </div>
            <div class="acceso-card">
                <div class="icono">&#128101;</div>
                <h3>Usuarios</h3>
                <p>Gestionar cuentas y roles de la plataforma</p>
                <h:link outcome="/usuarios/lista" styleClass="btn btn-primary mt-2">Ir a Usuarios</h:link>
            </div>
            <div class="acceso-card">
                <div class="icono">&#128202;</div>
                <h3>Reportes</h3>
                <p>Monedas en circulacion y partidos con mas predicciones</p>
                <h:link outcome="/reportes/lista" styleClass="btn btn-primary mt-2">Ver reportes</h:link>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF
echo "OK"

# =============================================================================
# XHTML - partidos/lista.xhtml
# =============================================================================
echo "=== Creando vistas de Partidos ==="

cat > src/main/webapp/partidos/lista.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:f="jakarta.faces.core"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Partidos</ui:define>
    <ui:define name="cabecera">Gestion de partidos</ui:define>

    <ui:define name="contenido">
        <div class="card">
            <div class="card-header">Calendario del torneo</div>
            <div class="card-body">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Local</th>
                                <th>Visitante</th>
                                <th>Fecha/Hora UTC</th>
                                <th>Sede</th>
                                <th>Fase</th>
                                <th>Estado</th>
                                <th>Marcador</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <ui:repeat value="#{partidoBean.partidos}" var="p">
                                <tr>
                                    <td>#{p.numeroPartidoFifa}</td>
                                    <td>#{p.nombreSeleccionLocal}</td>
                                    <td>#{p.nombreSeleccionVisitante}</td>
                                    <td>
                                        <h:outputText value="#{p.fechaHoraUtc}">
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </td>
                                    <td>#{p.nombreSede}</td>
                                    <td>#{p.nombreFase}</td>
                                    <td>
                                        <span class="badge badge-info">#{p.estado}</span>
                                    </td>
                                    <td>#{p.golesLocal} - #{p.golesVisitante}</td>
                                    <td>
                                        <h:form style="display:inline">
                                            <h:commandButton value="Editar"
                                                             styleClass="btn btn-warning btn-sm"
                                                             action="#{partidoBean.prepararEditar(p)}"/>
                                        </h:form>
                                        <h:form style="display:inline">
                                            <h:commandButton value="Registrar resultado"
                                                             styleClass="btn btn-success btn-sm"
                                                             action="#{partidoBean.prepararResultado(p)}"/>
                                        </h:form>
                                    </td>
                                </tr>
                            </ui:repeat>
                            <ui:fragment rendered="#{empty partidoBean.partidos}">
                                <tr>
                                    <td colspan="9" class="text-center text-muted">
                                        No hay partidos registrados.
                                    </td>
                                </tr>
                            </ui:fragment>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF

cat > src/main/webapp/partidos/resultado.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:f="jakarta.faces.core"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Registrar resultado</ui:define>
    <ui:define name="cabecera">Registrar resultado oficial</ui:define>

    <ui:define name="contenido">
        <div class="card" style="max-width:480px;margin:0 auto;">
            <div class="card-header">
                #{partidoBean.partidoSeleccionado.nombreSeleccionLocal} vs
                #{partidoBean.partidoSeleccionado.nombreSeleccionVisitante}
            </div>
            <div class="card-body">
                <h:form id="formResultado">
                    <div class="form-grid" style="grid-template-columns:1fr 1fr;">
                        <div class="form-group">
                            <h:outputLabel for="golesLocal"
                                value="Goles #{partidoBean.partidoSeleccionado.nombreSeleccionLocal} *"/>
                            <h:inputText id="golesLocal"
                                         value="#{partidoBean.golesLocalForm}"
                                         required="true"
                                         requiredMessage="Ingrese los goles del local.">
                                <f:convertNumber integerOnly="true"/>
                            </h:inputText>
                            <h:message for="golesLocal" styleClass="msg-error"/>
                        </div>
                        <div class="form-group">
                            <h:outputLabel for="golesVisitante"
                                value="Goles #{partidoBean.partidoSeleccionado.nombreSeleccionVisitante} *"/>
                            <h:inputText id="golesVisitante"
                                         value="#{partidoBean.golesVisitanteForm}"
                                         required="true"
                                         requiredMessage="Ingrese los goles del visitante.">
                                <f:convertNumber integerOnly="true"/>
                            </h:inputText>
                            <h:message for="golesVisitante" styleClass="msg-error"/>
                        </div>
                    </div>
                    <p class="text-muted mt-2">
                        Al confirmar, se notifica automaticamente al Servicio UTNGolCoin
                        para liquidar las predicciones de este partido.
                    </p>
                    <div class="form-actions">
                        <h:commandButton value="Cancelar"
                                         styleClass="btn btn-outline"
                                         action="#{partidoBean.cancelar()}"
                                         immediate="true"/>
                        <h:commandButton value="Confirmar resultado"
                                         styleClass="btn btn-success"
                                         action="#{partidoBean.guardarResultado()}"
                                         onclick="return confirm('Confirmar el resultado? Esta accion liquida las predicciones.')"/>
                    </div>
                </h:form>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF
echo "OK"

# =============================================================================
# XHTML - usuarios/lista.xhtml
# =============================================================================
echo "=== Creando vistas de Usuarios ==="

cat > src/main/webapp/usuarios/lista.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Usuarios</ui:define>
    <ui:define name="cabecera">Gestion de usuarios</ui:define>

    <ui:define name="contenido">
        <div class="card">
            <div class="card-header">Cuentas registradas</div>
            <div class="card-body">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Nombre</th>
                                <th>Email</th>
                                <th>Username</th>
                                <th>Rol</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <ui:repeat value="#{usuarioBean.usuarios}" var="u">
                                <tr>
                                    <td>#{u.idUsuario}</td>
                                    <td>#{u.nombre}</td>
                                    <td>#{u.email}</td>
                                    <td>#{u.username}</td>
                                    <td>#{u.nombreRol}</td>
                                    <td>
                                        <h:panelGroup rendered="#{u.estado}">
                                            <span class="badge badge-success">Activo</span>
                                        </h:panelGroup>
                                        <h:panelGroup rendered="#{not u.estado}">
                                            <span class="badge badge-danger">Inactivo</span>
                                        </h:panelGroup>
                                    </td>
                                    <td>
                                        <h:form style="display:inline">
                                            <h:commandButton value="#{u.estado ? 'Deshabilitar' : 'Habilitar'}"
                                                             styleClass="btn btn-sm #{u.estado ? 'btn-danger' : 'btn-success'}"
                                                             action="#{usuarioBean.cambiarEstado(u)}"/>
                                        </h:form>
                                    </td>
                                </tr>
                            </ui:repeat>
                            <ui:fragment rendered="#{empty usuarioBean.usuarios}">
                                <tr>
                                    <td colspan="7" class="text-center text-muted">
                                        No hay usuarios registrados.
                                    </td>
                                </tr>
                            </ui:fragment>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF
echo "OK"

# =============================================================================
# CSS - paleta sobria de panel de control (distinta del frontend publico)
# =============================================================================
echo "=== Creando CSS ==="

cat > src/main/webapp/resources/css/estilos.css << 'EOF'
:root {
    --primary:       #1e293b;
    --primary-hover: #334155;
    --accent:        #2563a8;
    --success:       #15803d;
    --danger:        #b91c1c;
    --warning:       #b45309;
    --info:          #0369a1;
    --bg:            #f1f5f9;
    --bg-card:       #ffffff;
    --border:        #cbd5e1;
    --border-light:  #e2e8f0;
    --text:          #1e293b;
    --text-muted:    #64748b;
    --navbar-height: 60px;
    --shadow:        0 1px 3px rgba(0,0,0,.12), 0 1px 2px rgba(0,0,0,.08);
    --shadow-md:     0 4px 6px rgba(0,0,0,.10), 0 2px 4px rgba(0,0,0,.06);
    --radius:        6px;
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
    font-size: 14px; color: var(--text); background: var(--bg);
    min-height: 100vh; display: flex; flex-direction: column;
}

a { color: var(--accent); text-decoration: none; }
a:hover { color: var(--primary-hover); text-decoration: underline; }

.navbar {
    position: fixed; top: 0; left: 0; right: 0;
    height: var(--navbar-height); background: var(--primary); color: #fff;
    display: flex; align-items: center; padding: 0 2rem; gap: 2rem;
    box-shadow: var(--shadow-md); z-index: 1000;
}

.brand-link {
    font-size: 1.05rem; font-weight: 700;
    color: #fff !important; text-decoration: none !important; white-space: nowrap;
}

.navbar-menu { display: flex; list-style: none; gap: 0.25rem; flex: 1; }

.navbar-menu .nav-link {
    display: block; padding: 0.45rem 0.9rem; border-radius: var(--radius);
    color: rgba(255,255,255,.85) !important; font-weight: 500;
    transition: background .15s, color .15s; text-decoration: none !important;
}

.navbar-menu .nav-link:hover { background: rgba(255,255,255,.12); color: #fff !important; }
.navbar-user { margin-left: auto; }
.user-placeholder { font-size: .85rem; color: rgba(255,255,255,.7); }

.main-content {
    margin-top: var(--navbar-height); padding: 2rem; flex: 1;
    max-width: 1200px; width: 100%; margin-left: auto; margin-right: auto;
}

.page-header {
    display: flex; align-items: center; justify-content: space-between;
    margin-bottom: 1.5rem; padding-bottom: 1rem;
    border-bottom: 2px solid var(--border-light);
}

.page-title { font-size: 1.4rem; font-weight: 700; color: var(--primary); }
.page-actions { display: flex; gap: .75rem; }

.messages { margin-bottom: 1rem; }

.msg-error, .msg-info, .msg-warn {
    display: block; padding: .75rem 1rem; border-radius: var(--radius);
    margin-bottom: .5rem; font-size: .875rem;
}

.msg-error { background: #fef2f2; color: var(--danger);  border-left: 4px solid var(--danger); }
.msg-info  { background: #eff6ff; color: var(--info);    border-left: 4px solid var(--info); }
.msg-warn  { background: #fffbeb; color: var(--warning);  border-left: 4px solid var(--warning); }

.card { background: var(--bg-card); border-radius: var(--radius); box-shadow: var(--shadow); overflow: hidden; }
.card-header { padding: 1rem 1.5rem; border-bottom: 1px solid var(--border-light); font-weight: 600; font-size: .95rem; }
.card-body { padding: 1.5rem; }

.index-hero { text-align: center; padding: 2rem 1rem 1.5rem; }
.index-hero h2 { font-size: 1.6rem; color: var(--primary); margin-bottom: .5rem; }
.index-hero p { color: var(--text-muted); font-size: 1rem; }

.accesos-grid {
    display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1.25rem; margin-top: 2rem;
}

.acceso-card {
    background: var(--bg-card); border-radius: var(--radius); box-shadow: var(--shadow);
    padding: 2rem 1.5rem; text-align: center; transition: box-shadow .2s, transform .2s;
}
.acceso-card:hover { box-shadow: var(--shadow-md); transform: translateY(-2px); }
.acceso-card .icono { font-size: 2.5rem; margin-bottom: .75rem; }
.acceso-card h3 { font-size: 1rem; font-weight: 600; color: var(--primary); margin-bottom: .4rem; }
.acceso-card p { font-size: .8rem; color: var(--text-muted); }

.table-container { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; font-size: .875rem; }

thead th {
    background: var(--primary); color: #fff; font-weight: 600;
    padding: .75rem 1rem; text-align: left; white-space: nowrap;
}
thead th:first-child { border-radius: var(--radius) 0 0 0; }
thead th:last-child  { border-radius: 0 var(--radius) 0 0; }

tbody tr { border-bottom: 1px solid var(--border-light); }
tbody tr:hover { background: #f8fafc; }
tbody td { padding: .7rem 1rem; vertical-align: middle; }

.badge { display: inline-block; padding: .25rem .6rem; border-radius: 999px; font-size: .75rem; font-weight: 600; }
.badge-success { background: #dcfce7; color: var(--success); }
.badge-danger  { background: #fee2e2; color: var(--danger); }
.badge-info    { background: #e0f2fe; color: var(--info); }

.btn {
    display: inline-flex; align-items: center; gap: .4rem;
    padding: .45rem .9rem; border: none; border-radius: var(--radius);
    font-size: .875rem; font-weight: 500; cursor: pointer;
    transition: background .15s, opacity .15s;
    text-decoration: none !important; white-space: nowrap;
}
.btn:hover { opacity: .9; }
.btn-primary { background: var(--accent); color: #fff; }
.btn-primary:hover { background: #1d4ed8; }
.btn-success { background: var(--success); color: #fff; }
.btn-danger  { background: var(--danger); color: #fff; }
.btn-warning { background: var(--warning); color: #fff; }
.btn-outline { background: transparent; border: 1px solid var(--border); color: var(--text); }
.btn-sm { padding: .3rem .6rem; font-size: .8rem; }

.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem 1.5rem; }
.form-group { display: flex; flex-direction: column; gap: .35rem; }
.form-group label, .form-group .h-outputLabel { font-weight: 600; font-size: .85rem; }
.form-group input, .form-group select, .form-group textarea {
    padding: .5rem .7rem; border: 1px solid var(--border); border-radius: var(--radius);
    font-size: .875rem; font-family: inherit;
}
.full-width { grid-column: 1 / -1; }
.form-actions { display: flex; justify-content: flex-end; gap: .75rem; margin-top: 1.5rem; }

.text-center { text-align: center; }
.text-muted { color: var(--text-muted); }
.mt-2 { margin-top: .75rem; }

.footer { text-align: center; padding: 1.25rem; color: var(--text-muted); font-size: .8rem; }
EOF
echo "OK"

echo ""
echo "=== Listo. Estructura del proyecto creada. ==="
echo "Siguiente paso: mvn clean package  (o abrir en VS Code y revisar)"
