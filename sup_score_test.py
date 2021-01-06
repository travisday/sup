import random

def run():
    score = 0.0
    mod = 0.6
    cnt = 5
    for x in range(30):

        if (5 + (score // 50)) > cnt:
            cnt += 1

        for i in range(cnt):
            if score < 5:
                score = score + 1
            else:
                score = score + .2

            if score < 5:
                score = score + 1
            else:
                score = score + .4
            
            if random.randint(0,99) == 1:
                score += .25
        score += mod

    print(score)


run()