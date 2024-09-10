package br.com.challenge.parkingSearch.usuario.service;

import br.com.challenge.parkingSearch.usuario.DTO.VagaDTO;
import br.com.challenge.parkingSearch.usuario.model.Vaga;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

public interface VagaService {

    List<Vaga> findByCidade(String cidade);
    List<Vaga> findByBairro(String bairro);
    List<Vaga> findByRua(String rua);
    List<Vaga> findByEstado(String estado);
    Optional<VagaDTO> findById(Long id);

    Vaga saveVaga(Vaga vaga);

    List<Vaga> findAll();
    List<Vaga> findByProprietarioId(Long id);
    void deletarVaga(Long id);

    Vaga saveVagaComImagens(Vaga vaga, List<MultipartFile> imagens) throws IOException;
}
