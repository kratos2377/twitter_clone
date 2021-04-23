import express from 'express'
const router = express.Router()
import {followUser , unfollowUser , allFollowandUnfollowDetails} from '../controllers/friendDetailsControllers.js'

router.post('/follow' , followUser )
router.post('/unfollow' , unfollowUser )
router.post('/getDetails' , allFollowandUnfollowDetails)

export default router