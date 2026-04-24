from fastapi import FastAPI
from fastapi.responses import JSONResponse
from models import LoginModel, ProductModel
from database import collection
from datetime import datetime

app = FastAPI()


# LOGIN API
@app.post("/api/login")
async def login(data: LoginModel):
    if data.email == "user@example.com" and data.password == "Password123":
        return {
            "success": True,
            "message": "Login successful"
        }

    return JSONResponse(
        status_code=401,
        content={
            "success": False,
            "message": "Invalid email or password"
        }
    )


# GET PRODUCTS
@app.get("/api/products")
async def get_products():
    try:
        products = []
        for item in collection.find():
            products.append({
                "id": str(item["_id"]),
                "name": item["name"],
                "price": item["price"]
            })

        return {
            "success": True,
            "data": products
        }

    except Exception:
        return JSONResponse(
            status_code=500,
            content={
                "success": False,
                "message": "Failed to fetch products"
            }
        )


# ADD PRODUCT
@app.post("/api/products")
async def add_product(product: ProductModel):
    try:
        collection.insert_one({
            "name": product.name,
            "price": product.price,
            "createdat": datetime.utcnow()
        })

        return JSONResponse(
            status_code=201,
            content={
                "success": True,
                "message": "Product added successfully"
            }
        )

    except Exception:
        return JSONResponse(
            status_code=500,
            content={
                "success": False,
                "message": "Database insertion failed"
            }
        )