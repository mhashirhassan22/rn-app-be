from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_name: str = "rn-app-be"
    environment: str = "local"
    debug: bool = False
    # Origins allowed to call the API from a browser (Expo web). Native apps don't need CORS.
    cors_origins: list[str] = ["http://localhost:8081", "http://localhost:19006"]


@lru_cache
def get_settings() -> Settings:
    return Settings()
