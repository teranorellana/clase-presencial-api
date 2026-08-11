# 1. Imagen base
FROM node:24-alpine

# 2. Directorio de trabajo dentro del contenedor
WORKDIR /app

# 3. Copiar solo los archivos de dependencias primero
COPY package*.json ./

# 4. Instalar dependencias
RUN npm ci --omit=dev

# 5. Copiar el resto del código fuente
COPY . .

# 6. Generar el cliente de Prisma
RUN npx prisma generate

# 7. Crear un usuario no privilegiado
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# 8. Puerto que expone la aplicación
EXPOSE 3000

# 9. Comando de arranque
CMD npx prisma migrate deploy && node index.js