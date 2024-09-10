package br.com.challenge.parkingSearch.usuario.repository;

import br.com.challenge.parkingSearch.usuario.model.Proprietario;
import br.com.challenge.parkingSearch.usuario.model.Vaga;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VagaRepository extends JpaRepository<Vaga, Long> {

    // Método para buscar todas as vagas de um proprietário pelo ID do proprietário
    List<Vaga> findByProprietarioId(Long proprietarioId);
    Optional<Vaga> findById(Long id);


    List<Vaga> findByProprietario(Proprietario proprietario);

    // Métodos para buscar vagas por cidade, bairro, rua, estado
    List<Vaga> findByCidade(String cidade);
    List<Vaga> findByBairro(String bairro);
    List<Vaga> findByEstado(String estado);
    List<Vaga> findByRua(String rua);
}
