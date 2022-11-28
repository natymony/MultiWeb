FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app
COPY ["MultiWeb/MultiApp.csproj", "MultiWeb/"]
RUN dotnet restore "MultiWeb/MultiApp.csproj"
COPY . .
RUN dotnet build "MultiApp.csproj" -c Release

FROM build AS publish
RUN dotnet publish "MultiApp.csproj"-c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MultiApp.dll"]
