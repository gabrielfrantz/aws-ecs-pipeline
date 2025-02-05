# Usa uma imagem oficial do Python
FROM python:3.9

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia apenas o arquivo de dependências primeiro
COPY requirements.txt ./

# Instala as dependências antes de copiar o código-fonte
RUN pip install --no-cache-dir -r requirements.txt

# Agora copia a pasta app
COPY app/ /app

# Expõe a porta do aplicativo (se necessário)
EXPOSE 5000

# Comando de execução
CMD ["python", "main.py"]