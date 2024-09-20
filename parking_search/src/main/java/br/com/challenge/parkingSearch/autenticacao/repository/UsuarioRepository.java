package br.com.challenge.parkingSearch.autenticacao.repository;

import br.com.challenge.parkingSearch.autenticacao.usuario.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Optional<Usuario> findByEmail(String email);



}
