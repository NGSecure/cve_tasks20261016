
mocha.ui('bdd');
mocha.reporter('html');
var expect = chai.expect;

fixtures.path = '.';

var $ = window.jQuery;

describe("${FILENAME}", function () {

    beforeEach( function(done) {
        fixtures.clearCache()
        fixtures.cleanUp()
        fixtures.load('normalThemeTemplate.htm', done);
    } );

    var select = function(selector) {
        return $(selector, fixtures.window().document);
    };

    var selectInput = function(name) {
        return select('input[name="' + (name || "dc") + '"]');
    }

    var selectInCalendar = function(selector) {
        return $(selector, select('iframe').contents());
    };

    var setText = function(text, name) {
        var input = selectInput();
        var e = $.Event("keypress");
        e.which = e.keyCode = 13;
        return input.val(text).trigger(e);
    };

    var clickCal = function(done) {
        var img = select('a img[name="popcal"]');
        img.click();
        setTimeout(done, 200);
    };

    var clickCell = function(selector, done) {
        var aSelector = 'a.CellAnchor' + selector;
        var cell = selectInCalendar(aSelector);
        expect(cell).to.have.lengthOf(1);
        cell.click();
        setTimeout(done, 200);
    };

    it('Typing in', function(done) {
        setText('Blah');
        expect(selectInput().val().length).to.be.equal(4);
        done();
    });

    it('Popping up', function(done) {
        clickCal(function() {
            expect(selectInCalendar('#outerTable')).to.have.lengthOf(1);
            done();
        });
    });

    it('Choosing a date', function(done) {
        clickCal(function() {
            clickCell(':contains("15")', function(refreshedCell) {
                expect(selectInput().val().split('/')[0]).to.equal('15');
                done();
            });
        });
    });
});

mocha.run();


