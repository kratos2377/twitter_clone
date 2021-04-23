import express from 'express'
import dotenv from 'dotenv'
import connectDB from './config/db.js'
import userRoutes from './routes/userRoutes.js' 
import tweetRoutes from './routes/tweetRoutes.js'
import likeTweetRoutes from './routes/like_comment_routes.js'
import friendRoutes from './routes/friendroutes.js'
import bodyParser from 'body-parser'
import cors from 'cors';





dotenv.config();
const app = express()
app.use(cors())
app.use(bodyParser())
app.use(express.json())




app.use('/users' , userRoutes )
app.use('/tweet' , tweetRoutes)
app.use('/tweetOp' , likeTweetRoutes)
app.use('/friends' , friendRoutes)


app.listen(5000 , () => {
    console.log("Server started running at 5000")
})
