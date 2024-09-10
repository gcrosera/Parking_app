package br.com.challenge.parkingSearch.usuario.controller;

import br.com.challenge.parkingSearch.usuario.model.Proprietario;
import br.com.challenge.parkingSearch.usuario.model.Vaga;
import br.com.challenge.parkingSearch.usuario.service.ProprietarioService;
import br.com.challenge.parkingSearch.usuario.service.VagaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Controller
@RequestMapping("/proprietarios")
public class ProprietarioController {

    @Autowired
    private ProprietarioService proprietarioService;

    @Autowired
    private VagaService vagaService;

    @GetMapping("/{id}")
    public Proprietario getProprietarioById(@PathVariable Long id) {
        return proprietarioService.findById(id);
    }

    @GetMapping("/{id}/BucarVagas")
    public List<Vaga> getVagasByProprietarioId(@PathVariable Long id) {
        return vagaService.findByProprietarioId(id);
    }
}
