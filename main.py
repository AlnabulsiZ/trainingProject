from fastapi import FastAPI
from tables import create_tables
from forgot_password import rou as forgot_password_rou
from login import rou as login_rou
#-------------------------------------------------------
app = FastAPI()

create_tables()

app.include_router(login_rou)
app.include_router(forgot_password_rou)

