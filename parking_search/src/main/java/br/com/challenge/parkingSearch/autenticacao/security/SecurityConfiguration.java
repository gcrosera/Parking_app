package br.com.challenge.parkingSearch.autenticacao.security;

import br.com.challenge.parkingSearch.autenticacao.filter.UsuarioFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.header.writers.frameoptions.XFrameOptionsHeaderWriter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

    @Autowired
    private UsuarioFilter usuarioFilter;

    public static final String [] ENDPOINTS_WITH_AUTHENTICATION_NOT_REQUIRED = {
            "/users/login", // Url que usaremos para fazer login
            "/h2-console/**",
            "/users/register",
            "vagas/BuscarVagaPorId/{id}",
            "vagas/BuscarVagaPorId",
            "/uploads/**"
    };

    // Endpoints que requerem autenticação para serem acessados
    public static final String [] ENDPOINTS_WITH_AUTHENTICATION_REQUIRED = {
            "/users/test",
            "/proprietarios/{id}",
            "/proprietarios",
            "/proprietarios/{id}/BucarVagas",
            "/proprietarios/BucarVagas",
            "/vagas",
            "/vagas/novaVaga/{id}",
            "/vagas/novaVaga",
            "/vagas/buscarTodas",
            "/vagas/cidade/{cidade}",
            "/vagas/cidade",
            "/vagas/bairro/{bairro}",
            "/vagas/bairro",
            "/vagas/rua/{rua}",
            "/vagas/rua",
            "vagas/estado/{estado}",
            "vagas/estado",
            "vagas/BuscarVagaPorId/{id}",
            "vagas/BuscarVagaPorId",
            "/uploads/**"
    };

    // Endpoints que só podem ser acessador por usuários com permissão de cliente
    public static final String [] ENDPOINTS_CUSTOMER = {
            
    };

    // Endpoints que só podem ser acessador por usuários com permissão de administrador
    public static final String [] ENDPOINTS_ADMIN = {

    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        return httpSecurity
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeRequests(req -> {
                    req.requestMatchers(ENDPOINTS_WITH_AUTHENTICATION_NOT_REQUIRED).permitAll();
                    req.requestMatchers(ENDPOINTS_WITH_AUTHENTICATION_REQUIRED).permitAll();
                    //req.requestMatchers(ENDPOINTS_WITH_AUTHENTICATION_REQUIRED).authenticated(); trocar depois!
                    req.requestMatchers(ENDPOINTS_ADMIN).hasRole("ADMINISTRATOR");
                    req.requestMatchers(ENDPOINTS_CUSTOMER).hasRole("CUSTOMER");
                    req.anyRequest().denyAll();
                })
                .headers(headers -> headers
                        .addHeaderWriter(new XFrameOptionsHeaderWriter(XFrameOptionsHeaderWriter.XFrameOptionsMode.SAMEORIGIN)) // Configuração para permitir o uso do console H2 em um iframe
                )
                .cors(withDefaults())
                .addFilterBefore(usuarioFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("*")); // Substitua pelo URL do Flutter
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(false);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        source.registerCorsConfiguration("/uploads/**", configuration);
        return source;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}