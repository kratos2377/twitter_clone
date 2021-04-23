import Pool from 'pg-pool'
import dotenv from 'dotenv'

dotenv.config()

const userPool = new Pool({
    
    database: process.env.DATABASE_NAME,
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    port: 5432
})


export {userPool}