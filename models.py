from pydantic import BaseModel, EmailStr, Field

class LoginModel(BaseModel):
    email: EmailStr
    password: str = Field(min_length=6)

class ProductModel(BaseModel):
    name: str = Field(min_length=1)
    price: float = Field(gt=0)