import SwiftUI
import Combine

struct Pergunta {
    let texto: String
    let opcoes: [String]
    let respostaCorreta: Int
}

struct RankingItem: Identifiable, Codable {
    var id = UUID()
    let nome: String
    let pontos: Int
    let tempo: TimeInterval
    let tema: String
}

enum Tela {
    case login, menu, jogo, ranking, resultado
}

struct ContentView: View {
    
    @State private var telaAtual: Tela = .login
    @State private var nomeUsuario: String = ""
    @State private var nomeTemp: String = ""
    @State private var temaSelecionado: String = ""
    @State private var indicePergunta = 0
    @State private var acertos = 0
    @State private var perguntasEmbaralhadas: [Pergunta] = []
    @State private var ranking: [RankingItem] = []
    @State private var tempoInicio = Date()
    @State private var tempoFinal: TimeInterval = 0
    @State private var feedbackStatus: String? = nil
    @State private var bloqueiaBotoes = false
    @State private var pulosRestantes = 2
    @State private var dificuldadeSelecionada = "Normal"
    @State private var tempoRestante = 15.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    let bancoDeDados: [String: [Pergunta]] = [
        "Programação": [
            Pergunta(texto: "Qual palavra declara constante em Swift?", opcoes: ["var", "let", "const", "final"], respostaCorreta: 1),
            Pergunta(texto: "Java é uma linguagem...", opcoes: ["Compilada", "Interpretada", "Marcacao", "Script"], respostaCorreta: 0),
            Pergunta(texto: "Qual o criador do Python?", opcoes: ["Steve Jobs", "Guido van Rossum", "Mark Zuckerberg", "Bill Gates"], respostaCorreta: 1),
            Pergunta(texto: "Em Kotlin, como declarar variável mutável?", opcoes: ["val", "var", "let", "mutable"], respostaCorreta: 1),
            Pergunta(texto: "O que significa a sigla HTML?", opcoes: ["HyperText Markup Language", "High Tech Modern Language", "Hyperlink Text Mode", "Home Tool Markup"], respostaCorreta: 0),
            Pergunta(texto: "Qual símbolo inicia comentário em Python?", opcoes: ["//", "/*", "#", "--"], respostaCorreta: 2),
            Pergunta(texto: "Qual dessas é uma linguagem mobile?", opcoes: ["Swift", "HTML", "CSS", "SQL"], respostaCorreta: 0),
            Pergunta(texto: "O que faz o comando 'print'?", opcoes: ["Lê dados", "Exibe na tela", "Apaga arquivos", "Fecha o app"], respostaCorreta: 1),
            Pergunta(texto: "Qual o operador de igualdade em Java?", opcoes: ["=", "==", "===", "is"], respostaCorreta: 1),
            Pergunta(texto: "Python é conhecido por sua...", opcoes: ["Complexidade", "Sintaxe clara", "Lentidão", "Falta de bibliotecas"], respostaCorreta: 1)
        ],
        "História": [
            Pergunta(texto: "Quem descobriu o Brasil?", opcoes: ["Colombo", "Cabral", "Vasco da Gama", "Magalhães"], respostaCorreta: 1),
            Pergunta(texto: "Em que ano caiu o Muro de Berlim?", opcoes: ["1985", "1989", "1991", "1995"], respostaCorreta: 1),
            Pergunta(texto: "Quem foi o primeiro homem na Lua?", opcoes: ["Yuri Gagarin", "Neil Armstrong", "Buzz Aldrin", "Elon Musk"], respostaCorreta: 1),
            Pergunta(texto: "Qual país perdeu a 2ª Guerra?", opcoes: ["EUA", "França", "Alemanha", "Inglaterra"], respostaCorreta: 2),
            Pergunta(texto: "Onde surgiram as Olimpíadas?", opcoes: ["Roma", "Grécia", "Egito", "China"], respostaCorreta: 1),
            Pergunta(texto: "Quem proclamou a Independência do Brasil?", opcoes: ["Dom Pedro I", "Dom Pedro II", "Tiradentes", "Deodoro"], respostaCorreta: 0),
            Pergunta(texto: "Qual civilização construiu pirâmides?", opcoes: ["Incas", "Astecas", "Egípcios", "Maias"], respostaCorreta: 2),
            Pergunta(texto: "Em que século iniciou a Rev. Industrial?", opcoes: ["XVI", "XVII", "XVIII", "XIX"], respostaCorreta: 2),
            Pergunta(texto: "Quem foi Joana d'Arc?", opcoes: ["Rainha", "Guerreira Francesa", "Cientista", "Escritora"], respostaCorreta: 1),
            Pergunta(texto: "Qual era a capital do Império Romano?", opcoes: ["Atenas", "Roma", "Paris", "Londres"], respostaCorreta: 1)
        ],
        "Filmes/Séries": [
            Pergunta(texto: "Quem é o vilão de Vingadores: Ultimato?", opcoes: ["Loki", "Ultron", "Thanos", "Coringa"], respostaCorreta: 2),
            Pergunta(texto: "Em qual série há o 'Mundo Invertido'?", opcoes: ["Dark", "Stranger Things", "Elite", "The 100"], respostaCorreta: 1),
            Pergunta(texto: "Qual filme ganhou o primeiro Oscar?", opcoes: ["Wings", "Ben-Hur", "Titanic", "Avatar"], respostaCorreta: 0),
            Pergunta(texto: "Quem interpreta o Homem de Ferro?", opcoes: ["Brad Pitt", "Robert Downey Jr.", "Tom Cruise", "Chris Evans"], respostaCorreta: 1),
            Pergunta(texto: "Qual série tem dragões e tronos?", opcoes: ["The Witcher", "Game of Thrones", "Vikings", "Friends"], respostaCorreta: 1),
            Pergunta(texto: "Qual o nome do bruxo em Harry Potter?", opcoes: ["Ron", "Dumbledore", "Harry", "Snape"], respostaCorreta: 2),
            Pergunta(texto: "O filme 'Parasita' é de qual país?", opcoes: ["Japão", "China", "Coreia do Sul", "Brasil"], respostaCorreta: 2),
            Pergunta(texto: "Em Star Wars, quem é o pai de Luke?", opcoes: ["Obi-Wan", "Yoda", "Darth Vader", "Han Solo"], respostaCorreta: 2),
            Pergunta(texto: "Qual o nome do robô em Interestelar?", opcoes: ["R2D2", "TARS", "C3PO", "Wall-E"], respostaCorreta: 1),
            Pergunta(texto: "A série 'La Casa de Papel' é sobre...", opcoes: ["Polícia", "Assalto a banco", "Medicina", "Advocacia"], respostaCorreta: 1)
        ]
    ]
    
    var body: some View {
        VStack {
            switch telaAtual {
            case .login: loginView
            case .menu: menuView
            case .jogo: jogoView
            case .ranking: rankingView
            case .resultado: resultadoView
            }
        }
        .padding()
        .onAppear(perform: carregarRanking)
    }
    
    var loginView: some View {
        VStack(spacing: 20) {
            Text("Quiz Capgemini").font(.system(size: 30, weight: .black))
            TextField("Digite seu nome", text: $nomeTemp)
                .textFieldStyle(.roundedBorder).multilineTextAlignment(.center).padding()
            Button("Entrar") {
                if !nomeTemp.isEmpty { nomeUsuario = nomeTemp; telaAtual = .menu }
            }.buttonStyle(.borderedProminent)
        }
    }
    
    var menuView: some View {
        VStack(spacing: 20) {
            Text("Olá, \(nomeUsuario)!").font(.title)
            
            VStack {
                Text("Dificuldade").font(.caption).bold()
                Picker("Dificuldade", selection: $dificuldadeSelecionada) {
                    Text("Fácil (∞s)").tag("Fácil")
                    Text("Normal (15s)").tag("Normal")
                    Text("Difícil (5s)").tag("Difícil")
                }.pickerStyle(.segmented)
            }.padding(.horizontal)
            
            Button(action: { telaAtual = .ranking }) {
                Label("Ver Ranking", systemImage: "trophy.fill")
                    .frame(maxWidth: .infinity).padding().background(Color.orange).foregroundColor(.white).cornerRadius(15)
            }
            
            Text("Escolha um tema:").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(bancoDeDados.keys).sorted(), id: \.self) { tema in
                        Button(tema) { iniciarJogo(tema: tema) }.buttonStyle(.borderedProminent)
                    }
                }
            }
            Button("Trocar Jogador") { telaAtual = .login; nomeTemp = "" }.font(.caption).foregroundColor(.gray)
        }
    }
    
    var jogoView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("\(indicePergunta + 1) de 5").font(.caption)
                Spacer()
                if dificuldadeSelecionada != "Fácil" {
                    ProgressView(value: tempoRestante, total: dificuldadeSelecionada == "Normal" ? 15 : 5)
                        .tint(tempoRestante < 3 ? .red : .blue)
                        .frame(width: 100)
                }
                Spacer()
                if pulosRestantes > 0 {
                    Button(action: pularPergunta) {
                        Label("\(pulosRestantes)", systemImage: "forward.fill").font(.caption)
                    }.disabled(bloqueiaBotoes)
                }
            }
            
            Text(perguntasEmbaralhadas[indicePergunta].texto)
                .font(.title3).bold().multilineTextAlignment(.center).frame(height: 80)
            
            VStack(spacing: 12) {
                ForEach(0..<4) { index in
                    Button(action: { conferirResposta(index) }) {
                        Text(perguntasEmbaralhadas[indicePergunta].opcoes[index])
                            .frame(maxWidth: .infinity).padding()
                            .background(corDoBotao(index))
                            .foregroundColor(.primary).cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
                    }.disabled(bloqueiaBotoes)
                }
            }
        }
        .onReceive(timer) { _ in
            if telaAtual == .jogo && dificuldadeSelecionada != "Fácil" && !bloqueiaBotoes {
                if tempoRestante > 0 {
                    tempoRestante -= 0.1
                } else {
                    conferirResposta(-1)
                }
            }
        }
    }
    
    var rankingView: some View {
        VStack {
            Text("Hall da Fama").font(.largeTitle).bold()
            
            let temasOrdenados = Array(bancoDeDados.keys).sorted()
            
            TabView {
                ForEach(temasOrdenados, id: \.self) { tema in
                    VStack {
                        Text(tema)
                            .font(.headline)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        
                        let filtrado = ranking.filter { $0.tema == tema }
                            .sorted(by: { $0.pontos == $1.pontos ? $0.tempo < $1.tempo : $0.pontos > $1.pontos })
                        
                        if filtrado.isEmpty {
                            VStack(spacing: 20) {
                                Spacer()
                                Image(systemName: "tray.and.arrow.down")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text("Ainda não temos registros para \(tema).")
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .padding()
                        } else {
                            List(filtrado) { item in
                                HStack {
                                    Text(item.nome).bold()
                                    Spacer()
                                    Text("\(item.pontos) pts | \(String(format: "%.1fs", item.tempo))")
                                }.font(.system(size: 14))
                            }
                            .listStyle(.plain)
                        }
                    }
                    .tag(tema)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: 450)
            
            Button("Voltar") { telaAtual = .menu }
                .buttonStyle(.bordered)
                .padding()
        }
    }
    
    var resultadoView: some View {
        VStack(spacing: 20) {
            Text("Fim de Jogo!").font(.largeTitle).bold()
            Text("Dificuldade: \(dificuldadeSelecionada)")
            Text("Acertos: \(acertos) / 5")
            Text("Tempo Total: \(String(format: "%.1fs", tempoFinal))")
            Button("Salvar e Sair") { salvarEIrParaMenu() }.buttonStyle(.borderedProminent)
        }
    }
    
    func iniciarJogo(tema: String) {
        temaSelecionado = tema
        perguntasEmbaralhadas = Array((bancoDeDados[tema] ?? []).shuffled().prefix(5))
        acertos = 0; indicePergunta = 0; pulosRestantes = 2; feedbackStatus = nil; bloqueiaBotoes = false
        resetTimer()
        tempoInicio = Date()
        telaAtual = .jogo
    }
    
    func resetTimer() {
        if dificuldadeSelecionada == "Normal" { tempoRestante = 15.0 }
        else if dificuldadeSelecionada == "Difícil" { tempoRestante = 5.0 }
    }
    
    func pularPergunta() {
        pulosRestantes -= 1
        proximaEtapa()
    }
    
    func conferirResposta(_ index: Int) {
        bloqueiaBotoes = true
        let correta = perguntasEmbaralhadas[indicePergunta].respostaCorreta
        if index == correta {
            acertos += 1
            feedbackStatus = "correto"
        } else {
            feedbackStatus = "errado"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { proximaEtapa() }
    }
    
    func proximaEtapa() {
        feedbackStatus = nil
        bloqueiaBotoes = false
        if indicePergunta + 1 < 5 {
            indicePergunta += 1
            resetTimer()
        } else {
            tempoFinal = Date().timeIntervalSince(tempoInicio)
            telaAtual = .resultado
        }
    }
    
    func corDoBotao(_ index: Int) -> Color {
        guard let status = feedbackStatus else { return Color.gray.opacity(0.1) }
        let correta = perguntasEmbaralhadas[indicePergunta].respostaCorreta
        if index == correta { return .green.opacity(0.3) }
        if status == "errado" && index != correta { return .red.opacity(0.1) }
        return .gray.opacity(0.1)
    }
    
    func salvarEIrParaMenu() {
        let novo = RankingItem(nome: nomeUsuario, pontos: acertos, tempo: tempoFinal, tema: temaSelecionado)
        ranking.append(novo)
        if let data = try? JSONEncoder().encode(ranking) {
            UserDefaults.standard.set(data, forKey: "ranking_final_v6")
        }
        telaAtual = .menu
    }
    
    func carregarRanking() {
        if let data = UserDefaults.standard.data(forKey: "ranking_final_v6"),
           let decoded = try? JSONDecoder().decode([RankingItem].self, from: data) {
            ranking = decoded
        }
    }
}

#Preview {
    ContentView()
}
