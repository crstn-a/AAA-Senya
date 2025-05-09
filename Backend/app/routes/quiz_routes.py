from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models import Sign
from app.dependencies import get_db
import random

router = APIRouter(prefix="/quiz", tags=["Quiz"])

@router.get("/generate/{lesson_id}", summary="Generate smart quiz based on lesson")
async def generate_quiz(lesson_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Sign).where(Sign.lesson_id == lesson_id, Sign.archived == False)
    )
    raw_signs = result.scalars().all()

    # ✅ FILTER: keep only signs with non-empty video and text
    signs = [
        s for s in raw_signs
        if s.video_url and s.video_url.strip() != "" and s.text and s.text.strip() != ""
    ]
    
    print("✅ Signs used in quiz:")
    for s in signs:
        print(f" - {s.text} @ {s.video_url}")

    if not signs or len(signs) < 1:
        raise HTTPException(status_code=400, detail="Not enough valid signs to generate a quiz.")

    quiz = []
    for sign in signs:
        # 🎥 VIDEO_TO_TEXT
        text_pool = list({s.text for s in signs if s.text != sign.text})
        while len(text_pool) < 3:
            text_pool.append(random.choice([s.text for s in signs if s.text != sign.text]))
        distractors = random.sample(text_pool, 3)
        choices = distractors + [sign.text]
        random.shuffle(choices)

        quiz.append({
            "type": "video_to_text",
            "video_url": sign.video_url,
            "correct_answer": sign.text,
            "choices": choices
        })

        # 📺 TEXT_TO_VIDEO
        video_pool = list({s.video_url for s in signs if s.video_url != sign.video_url})
        while len(video_pool) < 3:
            video_pool.append(random.choice([s.video_url for s in signs if s.video_url != sign.video_url]))
        video_choices = random.sample(video_pool, 3)
        video_choices.append(sign.video_url)
        random.shuffle(video_choices)

        quiz.append({
            "type": "text_to_video",
            "question": f"Which video shows the sign for '{sign.text}'?",
            "correct_video": sign.video_url,
            "options": video_choices
        })

    return quiz

