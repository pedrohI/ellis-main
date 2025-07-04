# Use uma imagem Python oficial e leve como imagem base.
# A tag 'alpine' indica uma versão minimalista, resultando em imagens menores.
FROM python:3.13.5-alpine3.22

# Define o diretório de trabalho dentro do contêiner.
# Todos os comandos subsequentes (COPY, RUN, CMD) serão executados a partir deste diretório.
WORKDIR /app

# Copia o arquivo de dependências primeiro.
# Isso aproveita o cache de camadas do Docker. Se o requirements.txt não mudar,
# o Docker reutilizará a camada de dependências instaladas, acelerando builds futuros.
COPY requirements.txt .

# Instala as dependências do projeto.
# --no-cache-dir: Desabilita o cache do pip, o que ajuda a manter o tamanho da imagem menor.
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código da aplicação para o diretório de trabalho no contêiner.
COPY . .

# Expõe a porta 8000 para permitir a comunicação com a aplicação de fora do contêiner.
EXPOSE 8000

# Comando para executar a aplicação quando o contêiner for iniciado.
# --host 0.0.0.0: Faz com que o servidor seja acessível a partir de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
