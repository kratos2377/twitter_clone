import mongoose from 'mongoose'
import colors from 'colors'

const  connectDB = async () => {
  try {
  const connect = await mongoose.connect(process.env.MONGO_URI , {
    useUnifiedTopology: true,
    useNewUrlParser: true,
    useCreateIndex: true
  })

  console.log("DATABASE CONNECTED".green)
  } catch (err) {
    console.log(`Error: ${error.message}`.red.underline.bold)
  }
}

export default connectDB