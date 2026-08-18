import random

# Easy (Tier 0)
from mini_games.easy.speed_math import SpeedMathGame
from mini_games.easy.rhyme_challenge import RhymeChallengeGame
from mini_games.easy.short_reverse_word import ShortReverseWordGame
from mini_games.easy.fast_stop_bus import FastStopBusGame

# Medium (Tier 1)
from mini_games.medium.word_ban import WordBanGame
from mini_games.medium.odd_one_out import OddOneOutGame
from mini_games.medium.common_questions_logic import CommonQuestionsLogicGame
from mini_games.medium.last_letter_word_chain import LastLetterWordChainGame
from mini_games.medium.common_letter_finder import CommonLetterFinderGame

# Hard (Tier 2)
from mini_games.hard.tongue_twisters import TongueTwistersGame
from mini_games.hard.hard_stop_bus import HardStopBusGame
from mini_games.hard.fitness_challenges import FitnessChallengesGame
from mini_games.hard.stroop_effect import StroopEffectGame
from mini_games.hard.double_constraint_word import DoubleConstraintWordGame

TIER_GAMES = {
    0: [
        SpeedMathGame,
        RhymeChallengeGame,
        ShortReverseWordGame,
        FastStopBusGame,
    ],
    1: [
        WordBanGame,
        OddOneOutGame,
        CommonQuestionsLogicGame,
        LastLetterWordChainGame,
        CommonLetterFinderGame,
    ],
    2: [
        TongueTwistersGame,
        HardStopBusGame,
        FitnessChallengesGame,
        StroopEffectGame,
        DoubleConstraintWordGame,
    ],
}

def calculate_tier_from_steps(steps: int) -> int:
    """
    1-3 steps -> 0 (Easy)
    4-6 steps -> 1 (Medium)
    7-9 steps -> 2 (Hard)
    """
    if steps <= 3:
        return 0
    elif steps <= 6:
        return 1
    else:
        return 2

def get_random_game_class(tier: int):
    tier = max(0, min(2, tier))
    games_pool = TIER_GAMES.get(tier, TIER_GAMES[0])
    return random.choice(games_pool)

def create_mini_game(parent, steps: int, on_result=None, on_timeout=None):
    tier = calculate_tier_from_steps(steps)
    game_cls = get_random_game_class(tier)
    return game_cls(parent=parent, on_result=on_result, on_timeout=on_timeout)