class Meal:
    def __init__(self, name, protein, fat, kcal, carbs):
        self._name = name
        self._protein = protein
        self._fat = fat
        self._kcal = kcal
        self.carbs = carbs

class FastFood(Meal):
    def __init__(self):
        pass

class Vegetables:
    def __init__(self):
        pass

class Drinks:
    def __init__(self):
        pass
