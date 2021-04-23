import express from 'express'
const router = express.Router();
import {likeTweet , commentOnTweet , retweeted} from '../controllers/like_commentController.js'


router.post('/like', likeTweet )
router.post('/comment', commentOnTweet )
router.post('/retweet', retweeted )

export default router;