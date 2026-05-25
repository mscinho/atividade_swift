const express = require('express');
const app = express();
const PORT = 3000;

app.use(express.json());

let contatos = [];

// CADASTRAR
app.post('/contatos', (req, res) => {
    const { nome, email, telefone, nascimento, cep, bairro, logradouro, numero, estado, cidade } = req.body;

    if (!nome || !email || !telefone) {
        return res.status(400).json({ erro: "Nome, email e telefone são obrigatórios." });
    }

    const novoContato = {
        id: Date.now().toString(),
        nome, email, telefone, nascimento, cep, bairro, logradouro, numero, estado, cidade
    };

    contatos.push(novoContato);
    return res.status(201).json(novoContato);
});

// LISTAR
app.get('/contatos', (req, res) => {
    return res.json(contatos);
});

// ALTERAR
app.put('/contatos/:id', (req, res) => {
    const { id } = req.params;
    const { nome, email, telefone, nascimento, cep, bairro, logradouro, numero, estado, cidade } = req.body;

    const indice = contatos.findIndex(c => c.id === id);

    if (indice === -1) {
        return res.status(404).json({ erro: "Contato não encontrado." });
    }

    contatos[indice] = {
        id, nome, email, telefone, nascimento, cep, bairro, logradouro, numero, estado, cidade
    };

    return res.json(contatos[indice]);
});

// DELETAR
app.delete('/contatos/:id', (req, res) => {
    const { id } = req.params;
    const indice = contatos.findIndex(c => c.id === id);

    if (indice === -1) {
        return res.status(404).json({ erro: "Contato não encontrado." });
    }

    contatos.splice(indice, 1);
    return res.status(204).send();
});

// Inicia o servidor local
app.listen(PORT, () => {
    console.log(`Servidor rodando com sucesso em http://localhost:${PORT}`);
});
