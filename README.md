# PA2 - Pega Bode Mobile

Aplicativo mobile desenvolvido em **Flutter** para conectar **comerciantes ambulantes e locais** aos clientes de suas vizinhanças através de uma experiência estilo rede social.

Projeto estruturado utilizando a metodologia ágil multi-agente **BMAD (Benchmark Multi-Agent Agile Development)** e baseado nos artefatos da **Lean Inception** (`docs/linseption`).

---

## 🎯 Status da Entrega: Marco 2 - Onda 1 e 2 (100% Concluídas)

### Onda 1 (Fundação & Feed Essencial)
| Funcionalidade | Status | Detalhes Técnicos |
| :--- | :---: | :--- |
| **1. Criar Conta / Cadastro** | ✅ Concluído | Suporte a dois tipos de usuário (**Cliente** e **Vendedor Ambulante**), com validação de dados, obrigatoriedade de telefone e nome do ponto comercial. |
| **2. Login & Sessão** | ✅ Concluído | Autenticação segura, persistência de sessão integrada ao Supabase Auth. |
| **3. Criar Postagem** | ✅ Concluído | Formulário validado com catálogo de categorias estilo iFood, upload de foto via **Câmera/Galeria** e persistência no banco. |
| **4. Rolar / Visualizar Feed** | ✅ Concluído | Feed rolável com pull-to-refresh, barra horizontal de filtros por categoria e cards completos com fotos. |

### Onda 2 (Interação, Descoberta e Comunicação)
| Funcionalidade | Status | Detalhes Técnicos |
| :--- | :---: | :--- |
| **1. Curtir Postagem** | ✅ Concluído | Sistema de likes em tempo real persistido na tabela `likes` do Supabase. |
| **2. Pesquisar Perfil / Venda** | ✅ Concluído | Barra de busca embutida no Feed permitindo filtro case-insensitive e em tempo real dos lanches. |
| **3. Visualizar Perfil Completo** | ✅ Concluído | Tela dedicada de perfil do vendedor, com foto, telefone e catálogo completo (ListView) das postagens ativas exclusivas daquela loja. |
| **4. Conversa (Chat Real-Time)** | ✅ Concluído | Chat em tempo real utilizando `Supabase Realtime Streams`. Possui tela de **Caixa de Entrada** (Inbox) agrupada por usuários, balões estilo WhatsApp com fotinha e horário (Timestamp), além de **Notificação (Badge Vermelho)** contador no menu quando chegam novas mensagens. |

---

## 🛠️ Tecnologias e Arquitetura

- **Framework:** Flutter (Dart 3.8+)
- **Backend / Database:** [Supabase](https://supabase.com/) (PostgreSQL, Auth e Realtime Streams)
- **Plataformas:** Android, iOS, Web, Windows
- **Padrão Arquitetural:** Feature-Driven com Separação de Camadas (Model, Service, Screen, Widget):
  - `lib/core/`: Temas e estilos globais (`AppTheme`).
  - `lib/features/auth/`: Modelos, telas de Login e Cadastro, e `AuthService` conectado ao Supabase Auth.
  - `lib/features/feed/`: Modelos de postagem, categorias, formulário, exibição (Feed) e integração Supabase via `FeedService`.
  - `lib/features/profile/`: Tela de visualização detalhada do Ponto Comercial / Vendedor.
  - `lib/features/chat/`: Integração WebSockets de ponta-a-ponta (`ChatService`), UI de Caixa de Entrada (`InboxScreen`) e Mensagens (`ChatScreen`).
- **Testes Automatizados:** Test-Driven Development (TDD) com mais de 27 suítes de testes unitários e de widgets na pasta `test/`.

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK instalado e configurado no PATH
- Dispositivo Android (ou emulador) conectado com Depuração USB ativada
- Conexão à internet (app vinculado ao backend na nuvem)

### Passos
```bash
# 1. Navegue até a pasta da aplicação
cd app

# 2. Obtenha as dependências
flutter pub get

# 3. Execute os testes automatizados
flutter test

# 4. Inicie o app no dispositivo conectado
flutter run
```

---

## 👥 Metodologia BMAD

O desenvolvimento seguiu rigorosamente os papéis dos agentes especializados BMAD:
- 🎯 **John (Product Manager):** Definição de escopo, personas e respeito às restrições do MVP (sem entrega e sem intermediários de pagamento).
- 🎨 **Sally (UX Designer):** Ergonomia mobile, catálogo visual, layouts responsivos para perfis e UI do Chat Real-time.
- 📐 **Winston (System Architect):** Estruturação modular por features, configuração de Banco de Dados PostgreSQL no Supabase, regras RLS (Row Level Security) e WebSockets.
- 💻 **Amelia (Senior Software Engineer):** Implementação em Flutter com disciplina Test-First.
- 🧪 **Quinn (QA & Testes):** Testes unitários para regras de postagem, autenticação e validação de lógicas de pesquisa de feed.
