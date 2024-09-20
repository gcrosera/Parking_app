package br.com.challenge.parkingSearch.usuario.repository;

import br.com.challenge.parkingSearch.autenticacao.usuario.Usuario;
import br.com.challenge.parkingSearch.usuario.model.Proprietario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProprietarioRepository extends JpaRepository<Proprietario, Long> {

    Optional<Proprietario> findByUsuario(Usuario usuario);
}
