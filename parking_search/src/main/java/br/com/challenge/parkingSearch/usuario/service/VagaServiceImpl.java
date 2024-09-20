package br.com.challenge.parkingSearch.usuario.service;

import br.com.challenge.parkingSearch.usuario.DTO.VagaDTO;
import br.com.challenge.parkingSearch.usuario.model.Vaga;
import br.com.challenge.parkingSearch.usuario.repository.VagaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Service
public class VagaServiceImpl implements VagaService {

    @Autowired
    private VagaRepository vagaRepository;

    public Vaga saveVaga(Vaga vaga) {
        return vagaRepository.save(vaga);
    }

    @Override
    public List<Vaga> findAll() {
        return vagaRepository.findAll(); // Retorna todas as vagas do banco de dados
    }

    @Override
    public List<Vaga> findByCidade(String cidade) {
        return vagaRepository.findByCidade(cidade);
    }

    @Override
    public List<Vaga> findByProprietarioId(Long proprietarioId) {
        return vagaRepository.findByProprietarioId(proprietarioId);
    }

    @Override
    public List<Vaga> findByBairro(String bairro) {
        return vagaRepository.findByBairro(bairro);
    }

    @Override
    public List<Vaga> findByRua(String rua) {
        return vagaRepository.findByRua(rua);
    }

    @Override
    public List<Vaga> findByEstado(String estado) {
        return vagaRepository.findByEstado(estado);
    }

    @Override
    public void deletarVaga(Long id) {
        vagaRepository.deleteById(id);  // Deletar uma vaga pelo ID
    }


    public Optional<VagaDTO> findById(Long id) {
        Optional<Vaga> vagaOptional = vagaRepository.findById(id);
        if (vagaOptional.isPresent()) {
            Vaga vaga = vagaOptional.get();
            VagaDTO vagaDTO = new VagaDTO();
            vagaDTO.setId(vaga.getId());
            vagaDTO.setDescricao(vaga.getDescricao());
            vagaDTO.setPreco(vaga.getPreco());
            vagaDTO.setImagemUrl(vaga.getImagemUrl());
            vagaDTO.setCep(vaga.getCep());
            vagaDTO.setRua(vaga.getRua());
            vagaDTO.setNumero(vaga.getNumero());
            vagaDTO.setBairro(vaga.getBairro());
            vagaDTO.setCidade(vaga.getCidade());
            vagaDTO.setEstado(vaga.getEstado());
            vagaDTO.setProprietarioId(vaga.getProprietario() != null ? vaga.getProprietario().getId() : null);
            return Optional.of(vagaDTO);
        }
        return Optional.empty();
    }


    @Override
    public Vaga saveVagaComImagens(Vaga vaga, List<MultipartFile> imagens) throws IOException {
        List<String> imagemUrls = new ArrayList<>();
        String uploadDir = "uploads/";

        // Cria o diretório se ele não existir
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Verifica se as imagens foram enviadas
        if (imagens != null && !imagens.isEmpty()) {
            for (MultipartFile imagem : imagens) {
                if (!imagem.getContentType().startsWith("image/")) {
                    throw new IllegalArgumentException("Apenas arquivos de imagem são permitidos.");
                }

                if (imagem.getSize() > 5 * 1024 * 1024) { // Limita a 5MB
                    throw new IllegalArgumentException("O arquivo é muito grande.");
                }

                String imageName = System.currentTimeMillis() + "_" + imagem.getOriginalFilename();
                Path imagePath = uploadPath.resolve(imageName);
                Files.copy(imagem.getInputStream(), imagePath, StandardCopyOption.REPLACE_EXISTING);

                imagemUrls.add("/uploads/" + imageName);
            }
        }

        // Armazene as URLs das imagens como uma string concatenada
        vaga.setImagemUrls(Collections.singletonList(String.join(",", imagemUrls)));

        // Salva a vaga no banco de dados
        return vagaRepository.save(vaga);
    }


}
