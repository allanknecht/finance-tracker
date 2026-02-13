# Correção de Segurança - Rails Master Key

## Problema
A Rails Master Key foi exposta no repositório GitHub e detectada pelo GitGuardian.

## Ações Realizadas

1. ✅ **Criado `.gitignore`** - Garante que arquivos sensíveis não sejam commitados
2. ✅ **Removido `config/master.key` do histórico do Git** - Usando `git filter-branch`
3. ✅ **Gerada nova master key** - Nova chave criada em `config/master.key`
4. ✅ **Limpeza do repositório** - Refs antigos removidos e garbage collection executado

## Próximos Passos OBRIGATÓRIOS

### 1. Regenerar credentials.yml.enc
Como o arquivo `config/credentials.yml.enc` foi deletado, você precisa regenerá-lo:

```bash
# Se estiver usando Ruby 3.1 (conforme Gemfile)
rails credentials:edit

# Ou se precisar ajustar a versão do Ruby primeiro
```

### 2. Fazer Force Push para o GitHub
⚠️ **ATENÇÃO**: Isso reescreverá o histórico do repositório remoto. Certifique-se de que ninguém mais está trabalhando neste repositório ou coordene com sua equipe.

```bash
# Adicionar as mudanças
git add .gitignore config/database.yml render.yaml
git commit -m "Fix: Remove master key from history and add .gitignore"

# Force push (isso remove a master key antiga do GitHub)
git push origin master --force
```

### 3. Atualizar Variáveis de Ambiente
Se você já tinha a aplicação rodando em produção (Render, Heroku, etc.), você precisa:

1. Atualizar a variável de ambiente `RAILS_MASTER_KEY` com o valor da **nova** master key
2. O valor da nova master key está em `config/master.key` (não commite este arquivo!)

### 4. Verificar no GitGuardian
Após o force push, verifique no GitGuardian se o alerta foi resolvido. Pode levar alguns minutos para o GitGuardian reescanear o repositório.

## Importante

- ⚠️ A master key antiga (`d41195b42c40c7f34ebd41fff2f3142b`) está comprometida e não deve ser mais usada
- ✅ A nova master key está em `config/master.key` e está sendo ignorada pelo Git
- ✅ O `.gitignore` agora protege arquivos sensíveis
- ⚠️ Se você tinha secrets nas credentials antigas, precisará recriá-las com a nova chave

## Verificação

Para verificar se tudo está correto:

```bash
# Verificar se master.key está sendo ignorado
git check-ignore config/master.key

# Verificar se o arquivo não está no histórico
git log --all --full-history -- config/master.key
# (não deve retornar nada)
```
