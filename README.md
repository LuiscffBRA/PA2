# PA2 - AchaNaRua Mobile

Aplicativo mobile desenvolvido em **Flutter** para conectar **comerciantes ambulantes e locais** aos clientes de suas vizinhanças através de uma experiência estilo rede social.

Projeto estruturado utilizando a metodologia ágil multi-agente **BMAD (Benchmark Multi-Agent Agile Development)** e baseado nos artefatos da **Lean Inception** (`docs/linseption`).

---

## 🎯 Status da Entrega: Marco 1 (MVP) - Ondas 1, 2 e 3 (100% Concluídas)

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
| **4. Conversa (Chat Real-Time)** | ✅ Concluído | Chat em tempo real utilizando `Supabase Realtime Streams`. Possui tela de **Caixa de Entrada** (Inbox) agrupada por usuários, balões estilo WhatsApp com foto e timestamp, além de **Badge Contador** no menu inferior. |

### Onda 3 (Localização, Comentários & Transação PIX — Fechamento do MVP 🎯)
| Funcionalidade | Status | Detalhes Técnicos |
| :--- | :---: | :--- |
| **1. Editar Perfil** | ✅ Concluído | Tela `EditProfileScreen` permitindo atualização de Nome, Telefone, Nome Comercial, Ponto de Referência/Localização, Bio e Chave PIX com persistência no Supabase `profiles`. |
| **2. Comentar Postagens** | ✅ Concluído | Sistema completo de comentários públicos com `CommentModel`, contagem dinâmica nos cards, modal interativo `CommentsModal` com avatar, distintivo de vendedor e envio em tempo real. |
| **3. Localizar Vendedor** | ✅ Concluído | Seção de Ponto de Referência em destaque nos cards e perfil do vendedor, com botão integrado de redirecionamento para o **Google Maps** (`url_launcher`). |
| **4. Gerar Link / QR Code PIX** | ✅ Concluído | Geração de **QR Code PIX** e código **PIX Copia e Cola** no padrão EMV/BACEN via `PixHelper` e `PixPaymentModal`, permitindo pagamento instantâneo direto ao vendedor com botão de copiar para o Clipboard. |

---

## 🛠️ Tecnologias e Arquitetura

- **Framework:** Flutter (Dart 3.8+)
- **Backend / Database:** [Supabase](https://supabase.com/) (PostgreSQL, Auth e Realtime Streams)
- **Plataformas:** Android, iOS, Web, Windows
- **Padrão Arquitetural:** Feature-Driven com Separação de Camadas (Model, Service, Screen, Widget):
  - `lib/core/`: Temas (`AppTheme`), utilitários de pagamento (`PixHelper`) e configuração (`SupabaseConfig`).
  - `lib/features/auth/`: Modelos, telas de Login e Cadastro, e `AuthService` conectado ao Supabase Auth.
  - `lib/features/feed/`: Modelos de postagem e comentários (`PostModel`, `CommentModel`), catálogo de lanches, formulário, exibição (Feed) e integração Supabase via `FeedService`.
  - `lib/features/profile/`: Telas de visualização detalhada do Vendedor (`VendorProfileScreen`) e Edição de Perfil (`EditProfileScreen`).
  - `lib/features/chat/`: Integração WebSockets de ponta-a-ponta (`ChatService`), UI de Caixa de Entrada (`InboxScreen`) e Mensagens (`ChatScreen`).
  - `lib/features/payments/`: Modal de Pagamento PIX (`PixPaymentModal`) com geração de QR Code e código Copia e Cola.
- **Testes Automatizados:** Test-Driven Development (TDD) com 37 suítes de testes unitários e de widgets na pasta `test/`.

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
- 🎨 **Sally (UX Designer):** Ergonomia mobile, catálogo visual, layouts responsivos para perfis, UI de comentários e modal de pagamento PIX.
- 📐 **Winston (System Architect):** Estruturação modular por features, configuração de Banco de Dados PostgreSQL no Supabase, regras RLS (Row Level Security), WebSockets e padrão BACEN para PIX.
- 💻 **Amelia (Senior Software Engineer):** Implementação em Flutter com disciplina Test-First.
- 🧪 **Quinn (QA & Testes):** Testes unitários para regras de postagem, comentários, perfil, autenticação e validação do PIX (37 testes passando).
