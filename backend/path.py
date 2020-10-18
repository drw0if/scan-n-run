import requests
import time

from threading import Thread

class Test(Thread):

    def __init__(self, id = 1):
        Thread.__init__(self)

        self.runner_id = id
        self.points = [
            [204, 358],
            [164, 435],
            [202, 468],
            [283, 469],
            [369, 434],
            [423, 412],
            [435, 413],
            [486, 457],
            [545, 497],
            [588, 557],
            [667, 573],
            [685, 465],
            [686, 357],
            [682, 236],
            [678, 156],
            [611, 136],
            [534, 166],
            [465, 191],
            [423, 207]
        ]

    def run(self):
        time.sleep(1)

        for p in self.points:
            try:
                r = requests.get(f'http://localhost:5000/runner/{self.runner_id}/{p[0]}/{p[1]}')
            except Exception:
                pass

            print(r.status_code)

            time.sleep(1)

