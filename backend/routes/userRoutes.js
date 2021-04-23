import express from 'express'
const router = express.Router();
import { loginUser , registerUser , changePassword , 
    updateUser , changePhotoUrl , getAllUsers , getEverything } from '../controllers/userController.js'


router.route('/login').post( loginUser )
router.route('/register').post(registerUser)
router.route('/update').post(updateUser)
router.route('/changepassword').post(changePassword)
router.route('/changePhoto').post(changePhotoUrl)
router.post('/getUsers' , getAllUsers)
router.post('/getUserDet' , getEverything)





export default router