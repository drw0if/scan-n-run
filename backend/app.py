from flask import Flask
from flask import request, render_template, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from flask import jsonify

import datetime
from path import Test

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True

db = SQLAlchemy(app)

testThread = None

class Element(db.Model):
    __tablename__ = 'element'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(45), nullable=False)
    description = db.Column(db.String(200), nullable=False)

    @property
    def serialize(self):
        return {
            'id' : self.id,
            'name' : self.name,
            'description' : self.description
        }


class Station(db.Model):
    __tablename__ = 'station'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    x = db.Column(db.Integer, nullable=False)
    y = db.Column(db.Integer, nullable=False)
    current_element = db.Column(
        db.Integer, db.ForeignKey('element.id'), nullable=True)


    @property
    def serialize(self):
        return {
            'id' : self.id,
            'x' : self.x,
            'y' : self.y,
            'current_element' : self.current_element
        }


class Runner(db.Model):
    __tablename__ = 'runner'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(45), nullable=False, unique=True)
    current_element = db.Column(
        db.Integer, db.ForeignKey('element.id'), nullable=True)

    @property
    def serialize(self):
        position = History.query.filter_by(runner=self.id).order_by(History.timestamp.desc()).first()
        return {
            'id' : self.id,
            'name' : self.name,
            'current_element' : self.current_element,
            'x' : position.x if position is not None else None,
            'y' : position.y if position is not None else None
        }


class History(db.Model):
    __tablename__ = 'history'
    id = db.Column(db.Integer, primary_key=True)
    timestamp = db.Column(db.DateTime, nullable=False,
                          default=datetime.datetime.utcnow)
    x = db.Column(db.Integer, nullable=False)
    y = db.Column(db.Integer, nullable=False)
    element = db.Column(db.Integer, db.ForeignKey('element.id'), nullable=True)
    runner = db.Column(db.Integer, db.ForeignKey('runner.id'), nullable=False)
    # Pickup | Release | Stand
    operation = db.Column(db.String(45), nullable=True)

    @property
    def serialize(self):
        return {
            'id' : self.id,
            'timestamp' : self.timestamp,
            'x' : self.x,
            'y' : self.y,
            'element' : self.element,
            'runner' : self.runner,
            'operation' : self.operation
        }


class Beacon(db.Model):
    __tablename__ = 'beacon'
    id = db.Column(db.Integer, primary_key=True)
    x = db.Column(db.Integer, nullable=False)
    y = db.Column(db.Integer, nullable=False)

    @property
    def serialize(self):
        return {
            'id' : self.id,
            'x' : self.x,
            'y' : self.y
        }


db.drop_all()
db.create_all()

r = Runner(name='Biagio')
db.session.add(r)

r = Runner(name='Riccardo')
db.session.add(r)

r = Runner(name='Martino')
db.session.add(r)

r = Runner(name='Aleandro')
db.session.add(r)

e = Element(name='Primitivo di Manduria', description='Vino Tarantino')
db.session.add(e)

e = Element(name='Chianti', description='Vino toscano')
db.session.add(e)

e = Element(name='Negroamaro', description='Vino salentino')
db.session.add(e)

s = Station(x=136, y=320, current_element=1)
db.session.add(s)

s = Station(x=340, y=200, current_element=None)
db.session.add(s)

s = Station(x=486, y=575, current_element=None)
db.session.add(s)

s = Station(x=1017, y=181, current_element=None)
db.session.add(s)

s = Station(x=815, y=260, current_element=None)
db.session.add(s)

s = Station(x=1018, y=364, current_element=None)
db.session.add(s)

s = Station(x=1018, y=552, current_element=None)
db.session.add(s)

s = Station(x=486, y=575, current_element=None)
db.session.add(s)

s = Station(x=813, y=424, current_element=None)
db.session.add(s)

s = Station(x=488, y=376)
db.session.add(s)

s = Station(x=439, y=575)
db.session.add(s)

s = Station(x=328, y=373)
db.session.add(s)

s = Station(x=257, y=572)
db.session.add(s)


b = Beacon(x=54, y=155)
db.session.add(b)

b = Beacon(x=54, y=421)
db.session.add(b)

b = Beacon(x=210, y=160)
db.session.add(b)

b = Beacon(x=205, y=421)
db.session.add(b)

b = Beacon(x=256, y=284)
db.session.add(b)

b = Beacon(x=259, y=126)
db.session.add(b)

b = Beacon(x=520, y=231)
db.session.add(b)

b = Beacon(x=507, y=120)
db.session.add(b)

b = Beacon(x=736, y=117)
db.session.add(b)

b = Beacon(x=248, y=332)
db.session.add(b)

b = Beacon(x=248, y=611)
db.session.add(b)

b = Beacon(x=738, y=611)
db.session.add(b)

b = Beacon(x=604, y=335)
db.session.add(b)

db.session.commit()


@app.route('/')
def index():
    return redirect(url_for('map'))

# Map display
@app.route('/map')
def map():
    return render_template('map.html')


@app.route('/map/stations')
def return_stations():
    return jsonify([x.serialize for x in Station.query.all()]), 200


@app.route('/map/beacons')
def return_beacons():
    return jsonify([x.serialize for x in Beacon.query.all()]), 200


@app.route('/map/runners')
def return_runners():
    return jsonify([x.serialize for x in Runner.query.all()]), 200


@app.route('/map/elements')
def return_elements():
    return jsonify([x.serialize for x in Element.query.all()]), 200


@app.route('/map/history/<int:element_id>')
def return_history(element_id):
    if Element.query.filter_by(id=element_id).first() is None:
        return '{}', 404

    data = History.query.filter_by(element=element_id).order_by(History.timestamp.asc()).all()
    return jsonify([x.serialize for x in data]), 200


@app.route('/map/<int:element_id>')
def path(element_id):
    if Element.query.filter_by(id=element_id).first() is None:
        return '{}', 404
    return render_template('path.html')


@app.route('/admin/stations')
def show_stations():

    data = [u.__dict__ for u in Station.query.all()]

    return render_template('table.html',
        title='Stations',
        header=['ID', 'X', 'Y', 'Current Element'],
        data=data,
        keys=['id', 'x', 'y', 'current_element']
    )


@app.route('/admin/runners')
def show_runners():

    data = [u.__dict__ for u in Runner.query.all()]

    return render_template('table.html',
        title='Runners',
        header=['ID', 'Name', 'Current Element'],
        data = data,
        keys=['id', 'name', 'current_element']
    )


@app.route('/admin/beacons')
def show_beacons():

    data = [u.__dict__ for u in Beacon.query.all()]

    return render_template('table.html',
        title='Beacons',
        header=['ID', 'X', 'Y'],
        data = data,
        keys=['id', 'x', 'y']
    )


@app.route('/admin/elements')
def show_element():

    data = [u.__dict__ for u in Element.query.all()]

    return render_template('table.html',
        title='Element',
        header=['ID', 'Name', 'Description'],
        data = data,
        keys=['id', 'name', 'description'],
        href='/map'
    )


# Runner register (ADMIN)
@app.route('/runner/register/<name>')
def runner_register(name):
    try:
        r = Runner(name=name)
        db.session.add(r)
        db.session.flush()

        return jsonify({'id': r.id, 'name': r.name}), 202
    except Exception:
        return '{}', 500


# Runner login
@app.route('/runner/login/<name>')
def runner_login(name):
    try:
        r = Runner.query.filter_by(name=name).first()

        if r is None:
            return '{}', 404

        h = History(x=150, y=360, runner=1, element=None, operation='stand')

        db.session.add(h)
        db.session.commit()

        return jsonify({
            'id': r.id,
            'name': r.name,
            'current_element': r.current_element
        }), 200
    except Exception:
        return '{}', 500


# Station register (ADMIN)
@app.route('/station/register/<int:x>/<int:y>')
def station_register(x, y):
    try:
        s = Station(x=x, y=y)

        db.session.add(s)
        db.session.flush()

        return jsonify({
            'id': s.id,
            'x': s.x,
            'y': s.y
        }), 202

    except Exception as e:
        return '{}', 500


# Element pickup from Station (RUNNER)
@app.route('/runner/<int:runner_id>/pickup/<int:station_id>/')
def pickup_element(runner_id, station_id):
    try:
        s = Station.query.filter_by(id=station_id).first()

        if s is None:
            raise Exception

        if s.current_element is None:
            raise Exception

        r = Runner.query.filter_by(id=runner_id).first()

        if r is None:
            raise Exception

        if r.current_element is not None:
            raise Exception

        r.current_element = s.current_element
        s.current_element = None

        lastH = History.query.filter_by(runner=runner_id).order_by(History.timestamp.desc()).first()

        if lastH is not None:
            x = lastH.x
            y = lastH.y
        else:
            x = s.x
            y = s.y

        h = History(x=x, y=y, runner=r.id,
                    element=r.current_element, operation='pickup')

        db.session.add(h)
        db.session.commit()

        testThread = Test(r.id)
        testThread.run()

        return jsonify({
            'x': s.x,
            'y': s.y,
            'runner': r.id,
            'element': r.current_element
        }), 202

    except KeyError:
        return '{}', 400
    except Exception:
        return '{}', 404


# Element release from Runner (RUNNER)
@app.route('/runner/<int:runner_id>/release/<int:station_id>/')
def release_element(runner_id, station_id):
    return_code = 200
    try:
        s = Station.query.filter_by(id=station_id).first()

        if s is None:
            raise Exception

        if s.current_element is not None:
            raise Exception

        r = Runner.query.filter_by(id=runner_id).first()

        if r is None:
            raise Exception

        if r.current_element is None:
            raise Exception

        s.current_element = r.current_element
        r.current_element = None

        lastH = History.query.filter_by(runner=runner_id).order_by(History.timestamp.desc()).first()

        if lastH is not None:
            x = lastH.x
            y = lastH.y
        else:
            x = s.x
            y = s.y

        h = History(x=x, y=y, runner=r.id,
                    element=s.current_element, operation='release')

        db.session.add(h)
        db.session.flush()

        return jsonify({
            'x': s.x,
            'y': s.y,
            'runner': r.id,
            'element': s.current_element
        }), 202

    except KeyError:
        return '{}', 400
    except Exception:
        return f'{return_code}', 404


@app.route('/runner/<int:runner_id>/<int:x>/<int:y>')
def addHistory(runner_id, x, y):
    try:

        r = Runner.query.filter_by(id=runner_id).first()

        if r is None:
            raise Exception

        h = History(x=x, y=y, runner=r.id, element=r.current_element, operation='stand')

        db.session.add(h)
        db.session.commit()

        return '{}', 202

    except Exception:
        return '{}', 404

@app.route('/runner/<int:runner_id>/calculate', methods=['POST'])
def calculate(runner_id):
    try:

        r = Runner.query.filter_by(id=runner_id).first()

        if r is None:
            raise Exception

        if request.json is None:
            raise Exception

        points = []

        available = request.json[:3]

        if len(available) != 3:
            raise Exception

        for p in available:
            s = Station.query.filter_by(id=p['station_id']).first()

            if s is None:
                raise Exception

            points += [s.x, s.y, p['distance']]

        x, y = trilateration(*points)

        h = History(x=x, y=y, runner=r.id,
                    element=r.current_element, operation='stand')

        return jsonify({
            'x': x,
            'y': y
        }), 200
    except Exception as e:
        print(e)
        return '{}', 404


def trilateration(x1, y1, r1, x2, y2, r2, x3, y3, r3):
    A = 2*x2 - 2*x1
    B = 2*y2 - 2*y1
    C = r1**2 - r2**2 - x1**2 + x2**2 - y1**2 + y2**2
    D = 2*x3 - 2*x2
    E = 2*y3 - 2*y2
    F = r2**2 - r3**2 - x2**2 + x3**2 - y2**2 + y3**2
    x = (C*E - F*B) / (E*A - B*D)
    y = (C*D - A*F) / (B*D - A*E)
    return x, y


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')