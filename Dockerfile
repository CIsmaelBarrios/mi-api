# Utiliza una imagen base de .NET
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Imagen de compilación de .NET
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["apiRender/apiRender.csproj", "apiRender/"]
RUN dotnet restore "apiRender/apiRender.csproj"
COPY . .
WORKDIR "/src/apiRender"
RUN dotnet build "apiRender.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "apiRender.csproj" -c Release -o /app/publish

# Construir la imagen final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "apiRender.dll"]
