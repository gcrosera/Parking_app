package br.com.challenge.parkingSearch.usuario.service;

import br.com.challenge.parkingSearch.usuario.model.Proprietario;
import br.com.challenge.parkingSearch.usuario.repository.ProprietarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProprietarioServiceImpl implements ProprietarioService {

    @Autowired
    private ProprietarioRepository proprietarioRepository;

    @Override
    public Proprietario findById(Long id) {
        return proprietarioRepository.findById(id).orElse(null);
    }

}
