import os

DEBUG = True

BASE_DIR = os.path.abspath(os.path.dirname(__file__))

THREADS_PER_PAGE = 2

CSRF_ENABLED = True

CSRF_SESSION_KEY = "secret"

SECRET_KEY = "secret"

# Enable protection agains *Cross-site Request Forgery (CSRF)*

# Use a secure, unique and absolutely secret key for
# signing the data.

# Secret key for signing cookies

# Define the database - we are working with
# SQLite for this example
# SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(BASE_DIR, 'app.db')
# DATABASE_CONNECT_OPTIONS = {}

# Application threads. A common general assumption is
# using 2 per available processor cores - to handle
# incoming requests using one and performing background
# operations using the other.