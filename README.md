# 📊 Cascavel em Números

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

**Inteligência Econômica - Cascavel em Números MVP**

Dashboard interativo para análise de indicadores econômicos do município de Cascavel/PR, oferecendo visualizações em tempo real de dados como PIB, empregos, empresas ativas, arrecadação e novos alvarás.

## 🎯 Sobre o Projeto

O **Cascavel em Números** é uma aplicação Flutter Web que centraliza e visualiza dados econômicos estratégicos do município de Cascavel. A plataforma oferece:

- **KPIs Principais**: PIB Municipal, Empregos Formais, Empresas Ativas, Arrecadação ISS e Novos Alvarás
- **Visualizações Interativas**: Gráficos e charts com dados históricos e tendências
- **Filtros Avançados**: Por período, CNAE e bairros
- **Alertas Inteligentes**: Notificações sobre variações significativas nos indicadores
- **Exportação de Dados**: Relatórios em CSV e PDF
- **Design Responsivo**: Interface adaptada para desktop e mobile

## 🚀 Tecnologias Utilizadas

- **Flutter 3.x**: Framework principal para desenvolvimento multiplataforma
- **Dart**: Linguagem de programação
- **Riverpod**: Gerenciamento de estado reativo
- **FL Chart**: Biblioteca para gráficos e visualizações
- **Intl**: Internacionalização e formatação (pt_BR)

### Dependências Principais

```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.2
  fl_chart: ^0.64.0          # Gráficos e charts
  intl: ^0.18.1              # Formatação pt_BR
  flutter_riverpod: ^2.4.9   # Gerenciamento de estado
```

## 🏗️ Arquitetura

O projeto segue uma arquitetura limpa e modular:

```
lib/
├── core/                   # Configurações centrais
│   ├── theme/             # Tema e estilos da aplicação
│   └── utils/             # Utilitários e formatadores
├── data/                  # Camada de dados
│   ├── models/            # Modelos de dados
│   └── repositories/      # Repositórios e fontes de dados
├── features/              # Funcionalidades por módulos
│   └── home/             # Dashboard principal
│       ├── pages/        # Páginas da feature
│       └── widgets/      # Componentes da UI
└── services/             # Serviços externos
```

## 📱 Funcionalidades

### Dashboard Principal
- **KPIs em Tempo Real**: Indicadores principais com variação mensal e anual
- **Gráficos Interativos**: Visualizações de séries temporais e comparativos
- **Filtros Dinâmicos**: Seleção por período, CNAE e localização
- **Alertas Automáticos**: Notificações sobre tendências importantes

### Exportação de Dados
- **CSV**: Dados tabulares para análises externas
- **PDF**: Relatórios formatados para apresentações

### Interface Responsiva
- **Desktop**: Layout otimizado para telas grandes
- **Mobile**: Interface adaptada para dispositivos móveis
- **Acessibilidade**: Controle de escala de texto e navegação intuitiva

## 🛠️ Instalação e Execução

### Pré-requisitos
- Flutter SDK 3.0.0 ou superior
- Dart SDK compatível
- Navegador web moderno (para Flutter Web)

### 🌐 Acesso Online

A aplicação está disponível online através do GitHub Pages:

**🔗 [https://fernandomarqss.github.io/SinergiaEconomica/](https://fernandomarqss.github.io/SinergiaEconomica/)**

### Passos para Instalação Local

1. **Clone o repositório**
```bash
git clone https://github.com/fernandomarqss/SinergiaEconomica.git
cd SinergiaEconomica
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute a aplicação**
```bash
# Para desenvolvimento web
flutter run -d chrome

# Para build de produção
flutter build web

# Para build com base-href específico (GitHub Pages)
flutter build web --release --base-href "/SinergiaEconomica/"
```

### 🚀 Deploy Automático

O projeto possui CI/CD configurado com GitHub Actions que:
- ✅ Faz build automático da aplicação Flutter Web
- ✅ Deploya automaticamente no GitHub Pages
- ✅ Atualiza a aplicação a cada push na branch `main`

## 📊 Dados e Indicadores

### KPIs Monitorados
- **PIB Municipal**: Produto Interno Bruto em milhões de reais
- **Empregos Formais**: Número total de postos de trabalho formais
- **Empresas Ativas**: Quantidade de empresas em atividade
- **Arrecadação ISS**: Imposto Sobre Serviços em milhões
- **Novos Alvarás**: Quantidade de alvarás emitidos no período

### Filtros Disponíveis
- **Período**: Dados mensais dos últimos 12 meses
- **CNAE**: Classificação Nacional de Atividades Econômicas
- **Bairros**: Principais regiões de Cascavel

## 🎨 Design System

O projeto utiliza um design system customizado baseado nas cores e identidade visual de Cascavel:

- **Cores Principais**: Verde Cascavel, Azul Heráldico
- **Tipografia**: Roboto como fonte principal
- **Componentes**: Cards, gráficos e botões padronizados
- **Responsividade**: Breakpoints para diferentes tamanhos de tela

## 🤝 Contribuição

Contribuições são bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Equipe

- **Fernando Marques** - [@fernandomarqss](https://github.com/fernandomarqss)

## 📞 Contato

Para dúvidas, sugestões ou parcerias:
- GitHub: [@fernandomarqss](https://github.com/fernandomarqss)
- Projeto: [SinergiaEconomica](https://github.com/fernandomarqss/SinergiaEconomica)

---

<div align="center">
  <strong>Desenvolvido com ❤️ para Cascavel/PR</strong>
</div>
