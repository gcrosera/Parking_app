package br.com.challenge.parkingSearch.usuario.controller;

import br.com.challenge.parkingSearch.usuario.DTO.VagaDTO;
import br.com.challenge.parkingSearch.usuario.model.Proprietario;
import br.com.challenge.parkingSearch.usuario.model.Vaga;
import br.com.challenge.parkingSearch.usuario.service.ProprietarioService;
import br.com.challenge.parkingSearch.usuario.service.VagaService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.nio.file.Path;
import java.nio.file.Paths;


@RestController
@RequestMapping("/vagas")
public class VagaController {

    @Autowired
    private VagaService vagaService;

    @Autowired
    private ProprietarioService proprietarioService;

    @PostMapping(value = "/novaVaga/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Vaga createVaga(@PathVariable("id") Long id,
                           @RequestPart("vaga") String vagaJson,
                           @RequestPart("imagens") List<MultipartFile> imagens) throws IOException {
        // Converte o JSON da vaga para VagaDTO
        ObjectMapper objectMapper = new ObjectMapper();
        VagaDTO vagaDTO = objectMapper.readValue(vagaJson, VagaDTO.class);

        // Restante da lógica para salvar a vaga
        Proprietario proprietario = proprietarioService.findById(id);

        Vaga vaga = new Vaga();
        vaga.setDescricao(vagaDTO.getDescricao());
        vaga.setPreco(vagaDTO.getPreco());
        vaga.setCep(vagaDTO.getCep());
        vaga.setRua(vagaDTO.getRua());
        vaga.setNumero(vagaDTO.getNumero());
        vaga.setBairro(vagaDTO.getBairro());
        vaga.setCidade(vagaDTO.getCidade());
        vaga.setEstado(vagaDTO.getEstado());
        vaga.setProprietario(proprietario);

        return vagaService.saveVagaComImagens(vaga, imagens);
    }

    @GetMapping("/buscarTodas")
    public List<VagaDTO> getAllVagas() {
        List<Vaga> vagas = vagaService.findAll();
        List<VagaDTO> vagaDTOs = new ArrayList<>();

        for (Vaga vaga : vagas) {
            VagaDTO vagaDTO = new VagaDTO();
            vagaDTO.setDescricao(vaga.getDescricao());
            vagaDTO.setPreco(vaga.getPreco());
            vagaDTO.setCep(vaga.getCep());
            vagaDTO.setRua(vaga.getRua());
            vagaDTO.setNumero(vaga.getNumero());
            vagaDTO.setBairro(vaga.getBairro());
            vagaDTO.setCidade(vaga.getCidade());
            vagaDTO.setEstado(vaga.getEstado());
            vagaDTO.setIdProprietario(vaga.getProprietario().getId()); // Inclua o ID do Proprietário
            vagaDTO.setImagemUrl(vaga.getImagemUrl());
            vagaDTO.setId(vaga.getId());

            vagaDTOs.add(vagaDTO);
        }

        return vagaDTOs;
    }

    @GetMapping(value = "/BuscarVagaPorId/{id}")
    public ResponseEntity<VagaDTO> buscarVagaPorId(@PathVariable("id") Long id) {
        Optional<VagaDTO> vagaDTOOptional = vagaService.findById(id);
        if (vagaDTOOptional.isPresent()) {
            return ResponseEntity.ok(vagaDTOOptional.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }


    @GetMapping("/cidade/{cidade}")
    public List<Vaga> getVagasByCidade(@PathVariable String cidade) {
        return vagaService.findByCidade(cidade);
    }

    @GetMapping("/bairro/{bairro}")
    public List<Vaga> getVagasByBairro(@PathVariable String bairro) {
        return vagaService.findByBairro(bairro);
    }

    @GetMapping("/rua/{rua}")
    public List<Vaga> getVagasByRua(@PathVariable String rua) {
        return vagaService.findByRua(rua);
    }

    @GetMapping("/estado/{estado}")
    public List<Vaga> getVagasByEstado(@PathVariable String estado) {
        return vagaService.findByEstado(estado);
    }

    @PostMapping("/upload")
    public ResponseEntity<String> uploadImage(@RequestParam("image") MultipartFile image) throws IOException {
        // Salvar imagem no servidor ou serviço externo (ex: AWS S3)
        String imageUrl = saveImage(image);

        return ResponseEntity.ok(imageUrl);
    }

    private String saveImage(MultipartFile image) throws IOException {
        // Lógica para salvar a imagem e retornar o link ou caminho da imagem
        // Exemplo: salvar localmente
        String fileName = UUID.randomUUID().toString() + "-" + image.getOriginalFilename();
        Path path = Paths.get("uploads/" + fileName);
        Files.copy(image.getInputStream(), path);

        // Retornar o caminho da imagem
        return "http://localhost:8080/uploads/" + fileName;
    }


}
