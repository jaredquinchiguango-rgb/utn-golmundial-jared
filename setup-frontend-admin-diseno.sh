#!/usr/bin/env bash
# =============================================================================
# setup-frontend-admin-diseno.sh
# PASO 5: Diseno visual sobrio tipo panel de control (RNF02)
# UTN GolMundial 2026 - Frontend Administrativo
#
# Requisito: haber ejecutado los pasos 1 a 4 antes.
# Uso: ejecutar desde la raiz del proyecto (donde esta el pom.xml)
#      cd $HOME/ProyectosUTN/frontend-admin
#      bash setup-frontend-admin-diseno.sh
#
# Este script SOLO toca: estilos.css, layout.xhtml, login.xhtml, index.xhtml
# y la celda de estado en partidos/lista.xhtml. No toca beans ni services.
# =============================================================================

set -e

# =============================================================================
# estilos.css - reescritura completa con el nuevo sistema de diseno
# =============================================================================
echo "=== Reescribiendo estilos.css ==="

cat > src/main/webapp/resources/css/estilos.css << 'EOF'
/* =====================================================================
   UTN GolMundial 2026 - Panel Administrativo
   Identidad: "mesa de control de comisario de partido" - sobria,
   tipografia de marcador de estadio, fichas de estado tipo tarjeta
   arbitral. Distinta a proposito del frontend publico (ese es el
   llamativo/mundialista; este es el de trabajo).
   ===================================================================== */

:root {
    /* Color */
    --ink:        #14191f;
    --ink-soft:   #1f2733;
    --ink-line:   #2b3542;
    --paper:      #f6f5f1;
    --paper-2:    #ffffff;
    --line:       #e3e1da;
    --text:       #1b222b;
    --text-muted: #6b7280;

    --pitch:       #2f6b4f;
    --pitch-dark:  #24523c;
    --pitch-tint:  #e4efe8;

    --gold:        #c99a3b;
    --gold-dark:   #a87c26;
    --gold-tint:   #f8efdc;

    --brick:       #a8402c;
    --brick-dark:  #872f1f;
    --brick-tint:  #f6e4e0;

    --info:        #35618c;
    --info-tint:   #e3ecf3;

    /* Tipografia */
    --font-display: 'Barlow Condensed', 'Arial Narrow', sans-serif;
    --font-body:    'Inter', system-ui, -apple-system, sans-serif;
    --font-mono:    'IBM Plex Mono', ui-monospace, 'Courier New', monospace;

    /* Layout */
    --sidebar-w:  232px;
    --topbar-h:   64px;
    --radius:     6px;
    --radius-sm:  4px;
    --shadow:     0 1px 2px rgba(20,25,31,.06);
    --shadow-md:  0 4px 10px rgba(20,25,31,.10);
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

@media (prefers-reduced-motion: reduce) {
    * { animation-duration: 0.001ms !important; transition-duration: 0.001ms !important; }
}

body {
    font-family: var(--font-body);
    font-size: 14px; color: var(--text); background: var(--paper);
    min-height: 100vh;
}

a { color: var(--pitch-dark); text-decoration: none; }
a:hover { text-decoration: underline; }

/* ---------------------------------------------------------------------
   Shell: rail lateral + area principal
   --------------------------------------------------------------------- */

.app-shell { display: flex; min-height: 100vh; }

.sidebar {
    width: var(--sidebar-w); flex-shrink: 0; background: var(--ink);
    color: #e8eaed; display: flex; flex-direction: column;
    position: sticky; top: 0; height: 100vh; overflow-y: auto;
}

.sidebar-brand {
    padding: 1.35rem 1.25rem 1.1rem; border-bottom: 1px solid var(--ink-line);
}
.sidebar-brand .brand-eyebrow {
    font-family: var(--font-display); font-size: .7rem; letter-spacing: .12em;
    color: var(--gold); text-transform: uppercase; font-weight: 600;
}
.sidebar-brand .brand-title {
    font-family: var(--font-display); font-size: 1.4rem; font-weight: 700;
    letter-spacing: .02em; color: #fff; text-transform: uppercase; line-height: 1.15;
}

.sidebar-nav { flex: 1; padding: 1rem .75rem; }
.nav-group { margin-bottom: 1.5rem; }
.nav-group-title {
    font-family: var(--font-display); font-size: .72rem; letter-spacing: .1em;
    text-transform: uppercase; color: #8b95a3; font-weight: 600;
    padding: 0 .6rem; margin-bottom: .4rem;
}
.nav-link {
    display: flex; align-items: center; gap: .65rem;
    padding: .5rem .6rem; border-radius: var(--radius-sm);
    color: #c7cdd6 !important; font-weight: 600; font-size: .87rem;
    text-decoration: none !important; transition: background .12s, color .12s;
}
.nav-link:hover { background: var(--ink-soft); color: #fff !important; }
.nav-link.active { background: var(--pitch-dark); color: #fff !important; }
.nav-icon { width: 17px; height: 17px; flex-shrink: 0; }

.sidebar-footer {
    padding: 1rem 1.1rem 1.25rem; border-top: 1px solid var(--ink-line);
}
.user-chip { display: flex; align-items: center; gap: .6rem; margin-bottom: .6rem; }
.user-avatar {
    width: 30px; height: 30px; border-radius: 50%; background: var(--pitch);
    display: flex; align-items: center; justify-content: center;
    font-family: var(--font-display); font-weight: 700; font-size: .85rem; color: #fff;
}
.user-name { font-size: .82rem; font-weight: 600; color: #fff; }
.user-role { font-size: .7rem; color: #8b95a3; text-transform: uppercase; letter-spacing: .05em; }
.logout-link {
    display: inline-flex; align-items: center; gap: .4rem;
    font-size: .8rem; font-weight: 600; color: #c7cdd6 !important;
}
.logout-link:hover { color: #fff !important; }

/* Estado no autenticado: sin rail, solo marca centrada arriba */
.app-shell-auth { flex-direction: column; }
.topbar.topbar-auth {
    justify-content: center; background: var(--ink); border-bottom: none;
    padding: 1.5rem 0;
}
.topbar.topbar-auth .brand-wordmark {
    font-family: var(--font-display); font-size: 1.3rem; font-weight: 700;
    letter-spacing: .04em; color: #fff; text-transform: uppercase;
}
.topbar.topbar-auth .brand-wordmark .accent { color: var(--gold); }

/* ---------------------------------------------------------------------
   Area principal
   --------------------------------------------------------------------- */

.app-main { flex: 1; min-width: 0; display: flex; flex-direction: column; }

.topbar {
    height: var(--topbar-h); background: var(--paper-2);
    border-bottom: 1px solid var(--line);
    display: flex; align-items: center; justify-content: space-between;
    padding: 0 2rem;
}
.page-title-group { display: flex; flex-direction: column; gap: .1rem; }
.eyebrow {
    font-family: var(--font-display); font-size: .72rem; letter-spacing: .12em;
    text-transform: uppercase; color: var(--pitch-dark); font-weight: 700;
}
.page-title {
    font-family: var(--font-display); font-size: 1.5rem; font-weight: 700;
    letter-spacing: .01em; color: var(--text); text-transform: uppercase;
}
.page-actions { display: flex; gap: .6rem; }

.main-content { flex: 1; padding: 2rem; max-width: 1220px; width: 100%; margin: 0 auto; }

.messages { margin-bottom: 1rem; }
.msg-error, .msg-info, .msg-warn {
    display: block; padding: .7rem 1rem; border-radius: var(--radius-sm);
    margin-bottom: .5rem; font-size: .85rem; font-weight: 500;
}
.msg-error { background: var(--brick-tint); color: var(--brick-dark); border-left: 3px solid var(--brick); }
.msg-info  { background: var(--pitch-tint); color: var(--pitch-dark); border-left: 3px solid var(--pitch); }
.msg-warn  { background: var(--gold-tint);  color: var(--gold-dark);  border-left: 3px solid var(--gold); }

.footer { text-align: center; padding: 1.1rem; color: var(--text-muted); font-size: .78rem; }

/* ---------------------------------------------------------------------
   Superficies
   --------------------------------------------------------------------- */

.card {
    background: var(--paper-2); border: 1px solid var(--line);
    border-radius: var(--radius); overflow: hidden;
}
.card-header {
    padding: .9rem 1.4rem; border-bottom: 1px solid var(--line);
    font-family: var(--font-display); font-size: 1rem; font-weight: 600;
    letter-spacing: .01em; text-transform: uppercase; color: var(--text);
}
.card-body { padding: 1.4rem; }

/* ---------------------------------------------------------------------
   Dashboard (index)
   --------------------------------------------------------------------- */

.index-hero { padding: .5rem 0 1.75rem; }
.index-hero .eyebrow { display: block; margin-bottom: .3rem; }
.index-hero h2 {
    font-family: var(--font-display); font-size: 1.9rem; font-weight: 700;
    text-transform: uppercase; color: var(--text);
}
.index-hero p { color: var(--text-muted); font-size: .95rem; margin-top: .3rem; }

.accesos-grid {
    display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1rem;
}
.acceso-card {
    background: var(--paper-2); border: 1px solid var(--line); border-radius: var(--radius);
    padding: 1.5rem; transition: border-color .15s, transform .15s;
}
.acceso-card:hover { border-color: var(--pitch); transform: translateY(-2px); }
.acceso-card .icono {
    width: 38px; height: 38px; border-radius: var(--radius-sm);
    background: var(--pitch-tint); color: var(--pitch-dark);
    display: flex; align-items: center; justify-content: center; margin-bottom: .9rem;
}
.acceso-card .icono svg { width: 20px; height: 20px; }
.acceso-card h3 {
    font-family: var(--font-display); font-size: 1.05rem; font-weight: 700;
    text-transform: uppercase; color: var(--text); margin-bottom: .3rem;
}
.acceso-card p { font-size: .82rem; color: var(--text-muted); margin-bottom: 1rem; }

/* ---------------------------------------------------------------------
   Tablas
   --------------------------------------------------------------------- */

.table-container { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; font-size: .87rem; }

thead th {
    background: var(--paper); color: var(--text-muted);
    font-family: var(--font-display); font-weight: 600; font-size: .78rem;
    letter-spacing: .06em; text-transform: uppercase;
    padding: .7rem 1rem; text-align: left; white-space: nowrap;
    border-bottom: 1px solid var(--line);
}

tbody tr { border-bottom: 1px solid var(--line); }
tbody tr:hover { background: var(--paper); }
tbody td { padding: .65rem 1rem; vertical-align: middle; }

.score { font-family: var(--font-mono); font-weight: 600; font-size: .95rem; }

/* ---------------------------------------------------------------------
   Fichas de estado (badges) - sistema clasico + fichas tipo tarjeta
   arbitral (elemento de firma del diseno)
   --------------------------------------------------------------------- */

.badge { display: inline-block; padding: .22rem .55rem; border-radius: 999px; font-size: .72rem; font-weight: 700; letter-spacing: .02em; }
.badge-success { background: var(--pitch-tint); color: var(--pitch-dark); }
.badge-danger  { background: var(--brick-tint); color: var(--brick-dark); }
.badge-info    { background: var(--info-tint);  color: var(--info); }

.badge-tag {
    display: inline-flex; align-items: center; gap: .4rem;
    padding: .28rem .65rem; border-radius: var(--radius-sm);
    font-family: var(--font-display); font-size: .75rem; font-weight: 700;
    letter-spacing: .04em; text-transform: uppercase;
}
.badge-gold    { background: var(--gold-tint);  color: var(--gold-dark); }
.badge-pitch   { background: var(--pitch-tint); color: var(--pitch-dark); }
.badge-neutral { background: var(--paper);      color: var(--text-muted); border: 1px solid var(--line); }

.live-dot {
    width: 7px; height: 7px; border-radius: 50%; background: var(--pitch-dark);
    display: inline-block; animation: pulse 1.4s ease-in-out infinite;
}
@keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: .35; } }

/* ---------------------------------------------------------------------
   Botones
   --------------------------------------------------------------------- */

.btn {
    display: inline-flex; align-items: center; gap: .4rem;
    padding: .48rem 1rem; border: 1px solid transparent; border-radius: var(--radius-sm);
    font-size: .84rem; font-weight: 600; cursor: pointer;
    transition: background .12s, border-color .12s, opacity .12s;
    text-decoration: none !important; white-space: nowrap; font-family: var(--font-body);
}
.btn:hover { opacity: .92; }
.btn-primary { background: var(--pitch-dark); color: #fff; }
.btn-success { background: var(--pitch); color: #fff; }
.btn-danger  { background: var(--brick); color: #fff; }
.btn-warning { background: var(--gold-dark); color: #fff; }
.btn-outline { background: var(--paper-2); border-color: var(--line); color: var(--text); }
.btn-outline:hover { border-color: var(--pitch); color: var(--pitch-dark); }
.btn-sm { padding: .32rem .65rem; font-size: .78rem; }

/* ---------------------------------------------------------------------
   Formularios
   --------------------------------------------------------------------- */

.form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem 1.5rem; }
.form-group { display: flex; flex-direction: column; gap: .35rem; }
.form-group label { font-weight: 600; font-size: .82rem; color: var(--text); }
.form-group input, .form-group select, .form-group textarea {
    padding: .5rem .7rem; border: 1px solid var(--line); border-radius: var(--radius-sm);
    font-size: .87rem; font-family: var(--font-body); background: var(--paper-2);
}
.form-group input:focus, .form-group select:focus, .form-group textarea:focus {
    outline: 2px solid var(--pitch); outline-offset: 1px; border-color: var(--pitch);
}
.full-width { grid-column: 1 / -1; }
.form-actions { display: flex; justify-content: flex-end; gap: .75rem; margin-top: 1.5rem; }

/* ---------------------------------------------------------------------
   Subtabs (catalogo: selecciones / grupos / sedes / fases)
   --------------------------------------------------------------------- */

.subtabs { display: flex; gap: .25rem; margin-bottom: 1rem; border-bottom: 1px solid var(--line); }
.subtab {
    padding: .55rem .95rem; font-family: var(--font-display); font-weight: 600;
    font-size: .82rem; letter-spacing: .03em; text-transform: uppercase;
    color: var(--text-muted) !important; text-decoration: none !important;
    border-bottom: 2px solid transparent; margin-bottom: -1px;
}
.subtab:hover { color: var(--pitch-dark) !important; }
.subtab-active { color: var(--pitch-dark) !important; border-bottom-color: var(--pitch); }

/* ---------------------------------------------------------------------
   Reportes / KPI
   --------------------------------------------------------------------- */

.reportes-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem; }
.kpi-card .card-body { padding: 1.75rem 1.5rem; text-align: center; }
.kpi-label {
    font-family: var(--font-display); font-size: .78rem; color: var(--text-muted);
    font-weight: 600; text-transform: uppercase; letter-spacing: .06em;
}
.kpi-value { font-family: var(--font-mono); font-size: 2.1rem; font-weight: 600; color: var(--pitch-dark); margin: .4rem 0; }

/* ---------------------------------------------------------------------
   Login
   --------------------------------------------------------------------- */

.login-wrap { display: flex; justify-content: center; padding: 3rem 1rem; }
.login-card { width: 100%; max-width: 400px; }
.login-card .card-header { text-align: center; }

/* ---------------------------------------------------------------------
   Utilidades
   --------------------------------------------------------------------- */

.text-center { text-align: center; }
.text-muted { color: var(--text-muted); }
.mt-2 { margin-top: .75rem; }
.mt-3 { margin-top: 1.5rem; }

/* ---------------------------------------------------------------------
   Responsivo (RNF01): el rail lateral pasa a barra horizontal
   --------------------------------------------------------------------- */

@media (max-width: 880px) {
    .app-shell { flex-direction: column; }
    .sidebar {
        width: 100%; height: auto; position: static;
        flex-direction: row; align-items: center; overflow-x: auto;
    }
    .sidebar-brand { border-bottom: none; border-right: 1px solid var(--ink-line); white-space: nowrap; }
    .sidebar-nav { display: flex; padding: .5rem; }
    .nav-group { display: flex; align-items: center; gap: .25rem; margin-bottom: 0; margin-right: 1rem; }
    .nav-group-title { display: none; }
    .nav-link { white-space: nowrap; }
    .sidebar-footer { border-top: none; border-left: 1px solid var(--ink-line); white-space: nowrap; }
    .topbar { padding: 0 1rem; flex-wrap: wrap; height: auto; padding-top: .75rem; padding-bottom: .75rem; }
    .main-content { padding: 1.25rem; }
}
EOF
echo "OK"

# =============================================================================
# layout.xhtml - rail lateral + topbar, iconos SVG, fuentes
# =============================================================================
echo "=== Actualizando layout.xhtml ==="

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
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@500;600;700&amp;family=Inter:wght@400;500;600;700&amp;family=IBM+Plex+Mono:wght@500;600&amp;display=swap" rel="stylesheet"/>
    <h:outputStylesheet library="css" name="estilos.css"/>
</h:head>

<h:body>

    <div class="app-shell #{loginBean.autenticado ? '' : 'app-shell-auth'}">

        <ui:fragment rendered="#{loginBean.autenticado}">
            <aside class="sidebar">
                <div class="sidebar-brand">
                    <div class="brand-eyebrow">GolMundial 2026</div>
                    <div class="brand-title">Panel Admin</div>
                </div>

                <nav class="sidebar-nav">
                    <div class="nav-group">
                        <div class="nav-group-title">Torneo</div>
                        <h:link outcome="/index" styleClass="nav-link">
                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
                                <rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>
                            </svg>
                            <span>Inicio</span>
                        </h:link>
                        <h:link outcome="/partidos/lista" styleClass="nav-link">
                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="7" cy="12" r="4"/><circle cx="17" cy="12" r="4"/><line x1="11" y1="12" x2="13" y2="12"/>
                            </svg>
                            <span>Partidos</span>
                        </h:link>
                        <h:link outcome="/selecciones/lista" styleClass="nav-link">
                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="5" y1="3" x2="5" y2="21"/><path d="M5 4h13l-3 4 3 4H5"/>
                            </svg>
                            <span>Selecciones</span>
                        </h:link>
                    </div>

                    <div class="nav-group">
                        <div class="nav-group-title">Cuentas</div>
                        <h:link outcome="/usuarios/lista" styleClass="nav-link">
                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="8" r="3.2"/><path d="M5 20c0-3.8 3.1-6.5 7-6.5s7 2.7 7 6.5"/>
                            </svg>
                            <span>Usuarios</span>
                        </h:link>
                    </div>

                    <div class="nav-group">
                        <div class="nav-group-title">Anal&#237;tica</div>
                        <h:link outcome="/reportes/lista" styleClass="nav-link">
                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="4" y1="21" x2="4" y2="12"/><line x1="12" y1="21" x2="12" y2="7"/><line x1="20" y1="21" x2="20" y2="15"/>
                            </svg>
                            <span>Reportes</span>
                        </h:link>
                    </div>
                </nav>

                <div class="sidebar-footer">
                    <div class="user-chip">
                        <div class="user-avatar"><span>#{loginBean.inicial}</span></div>
                        <div>
                            <div class="user-name">#{loginBean.usuarioActual.nombre}</div>
                            <div class="user-role">Administrador</div>
                        </div>
                    </div>
                    <h:form>
                        <h:commandLink styleClass="logout-link" action="#{loginBean.salir()}">
                            <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                                <polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/>
                            </svg>
                            <span>Salir</span>
                        </h:commandLink>
                    </h:form>
                </div>
            </aside>
        </ui:fragment>

        <div class="app-main">

            <ui:fragment rendered="#{loginBean.autenticado}">
                <header class="topbar">
                    <div class="page-title-group">
                        <span class="eyebrow"><ui:insert name="eyebrow">Panel administrativo</ui:insert></span>
                        <h1 class="page-title"><ui:insert name="cabecera">Inicio</ui:insert></h1>
                    </div>
                    <div class="page-actions"><ui:insert name="acciones"/></div>
                </header>
            </ui:fragment>

            <ui:fragment rendered="#{not loginBean.autenticado}">
                <header class="topbar topbar-auth">
                    <span class="brand-wordmark">GolMundial 2026 <span class="accent">&#183; Admin</span></span>
                </header>
            </ui:fragment>

            <main class="main-content">
                <h:messages globalOnly="true" styleClass="messages" errorClass="msg-error"
                            infoClass="msg-info" warnClass="msg-warn"/>
                <ui:insert name="contenido"><p>Sin contenido.</p></ui:insert>
            </main>

            <footer class="footer">
                <p>UTN GolMundial 2026 &#183; Panel Administrativo</p>
            </footer>
        </div>
    </div>

</h:body>
</html>
EOF
echo "OK"

# =============================================================================
# login.xhtml - restilizado (usa el shell "no autenticado" del layout)
# =============================================================================
echo "=== Actualizando login.xhtml ==="

cat > src/main/webapp/login.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Iniciar sesion - Panel Administrativo</ui:define>

    <ui:define name="contenido">
        <div class="login-wrap">
            <div class="card login-card">
                <div class="card-header">Acceso administrador</div>
                <div class="card-body">
                    <h:form id="formLogin">
                        <div class="form-grid" style="grid-template-columns:1fr;">
                            <div class="form-group">
                                <h:outputLabel for="correo" value="Correo *"/>
                                <h:inputText id="correo"
                                             value="#{loginBean.correo}"
                                             required="true"
                                             requiredMessage="El correo es obligatorio."/>
                                <h:message for="correo" styleClass="msg-error"/>
                            </div>
                            <div class="form-group">
                                <h:outputLabel for="clave" value="Clave *"/>
                                <h:inputSecret id="clave"
                                               value="#{loginBean.clave}"
                                               required="true"
                                               requiredMessage="La clave es obligatoria."
                                               redisplay="true"/>
                                <h:message for="clave" styleClass="msg-error"/>
                            </div>
                        </div>
                        <div class="form-actions" style="justify-content:center;">
                            <h:commandButton value="Ingresar"
                                             styleClass="btn btn-primary"
                                             action="#{loginBean.ingresar()}"/>
                        </div>
                    </h:form>
                </div>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF
echo "OK"

# =============================================================================
# index.xhtml - dashboard con iconos SVG en vez de emoji
# =============================================================================
echo "=== Actualizando index.xhtml ==="

cat > src/main/webapp/index.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">GolMundial 2026 - Panel Administrativo</ui:define>
    <ui:define name="eyebrow">Panel administrativo</ui:define>
    <ui:define name="cabecera">Inicio</ui:define>

    <ui:define name="contenido">
        <div class="index-hero">
            <span class="eyebrow">Mundial 2026 &#183; Estados Unidos, M&#233;xico y Canad&#225;</span>
            <h2>Mesa de control del torneo</h2>
            <p>Gestiona partidos, cuentas y revisa la actividad de UTNGolCoin.</p>
        </div>

        <div class="accesos-grid">
            <div class="acceso-card">
                <div class="icono">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="7" cy="12" r="4"/><circle cx="17" cy="12" r="4"/><line x1="11" y1="12" x2="13" y2="12"/>
                    </svg>
                </div>
                <h3>Partidos</h3>
                <p>Gestionar el calendario y registrar resultados oficiales</p>
                <h:link outcome="/partidos/lista" styleClass="btn btn-primary">Ir a partidos</h:link>
            </div>
            <div class="acceso-card">
                <div class="icono">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="8" r="3.2"/><path d="M5 20c0-3.8 3.1-6.5 7-6.5s7 2.7 7 6.5"/>
                    </svg>
                </div>
                <h3>Usuarios</h3>
                <p>Administrar cuentas registradas en la plataforma</p>
                <h:link outcome="/usuarios/lista" styleClass="btn btn-primary">Ir a usuarios</h:link>
            </div>
            <div class="acceso-card">
                <div class="icono">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="4" y1="21" x2="4" y2="12"/><line x1="12" y1="21" x2="12" y2="7"/><line x1="20" y1="21" x2="20" y2="15"/>
                    </svg>
                </div>
                <h3>Reportes</h3>
                <p>UTNGolCoin en circulaci&#243;n y partidos m&#225;s predichos</p>
                <h:link outcome="/reportes/lista" styleClass="btn btn-primary">Ver reportes</h:link>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF
echo "OK"

# =============================================================================
# partidos/lista.xhtml - solo se actualiza la celda de Estado y Marcador
# (fichas tipo tarjeta arbitral: el elemento de firma del diseno)
# =============================================================================
echo "=== Actualizando celda de estado en partidos/lista.xhtml ==="

cat > src/main/webapp/partidos/lista.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:f="jakarta.faces.core"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Partidos</ui:define>
    <ui:define name="eyebrow">Torneo</ui:define>
    <ui:define name="cabecera">Partidos</ui:define>

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
                                        <h:panelGroup rendered="#{p.estado eq 'programado'}">
                                            <span class="badge-tag badge-gold">Programado</span>
                                        </h:panelGroup>
                                        <h:panelGroup rendered="#{p.estado eq 'en_juego'}">
                                            <span class="badge-tag badge-pitch"><span class="live-dot"/> En juego</span>
                                        </h:panelGroup>
                                        <h:panelGroup rendered="#{p.estado eq 'finalizado'}">
                                            <span class="badge-tag badge-neutral">Finalizado</span>
                                        </h:panelGroup>
                                        <h:panelGroup rendered="#{p.estado ne 'programado' and p.estado ne 'en_juego' and p.estado ne 'finalizado'}">
                                            <span class="badge-tag badge-neutral">#{p.estado}</span>
                                        </h:panelGroup>
                                    </td>
                                    <td><span class="score">#{p.golesLocal} - #{p.golesVisitante}</span></td>
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
echo "OK"

echo ""
echo "=== Listo. Diseno sobrio tipo panel de control aplicado. ==="
echo "Compila y despliega de nuevo:"
echo "  mvn clean package"
echo "  cp target/frontend-admin.war \$HOME/programas/wildfly/standalone/deployments/"
