
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

    var selectInCalendar = function(selector) {
        return $(selector, select('iframe').contents());
    };

    var clickCell = function(selector, done) {
        var aSelector = 'a.CellAnchor' + selector;
        var cell = selectInCalendar(aSelector);
        expect(cell).to.have.lengthOf(1);
        cell.click();
        // cell seems to refer to a shadow copy of a DOM tree that will not
        // receive a refresh, so obtain the new jQuery object from the
        // refreshed DOM.
        setTimeout(done(selectInCalendar(aSelector)), 200);
    };

    it('Choosing a date', function(done) {
        clickCell(':contains("13")', function(refreshedCell) {
            expect(refreshedCell.parent().parent().attr("bgcolor")).to.equal('#DB5141');
            clickCell(':contains("15")', function(refreshedCell) {
                expect(refreshedCell.parent().parent().attr("bgcolor")).to.equal('#DB5141');
                expect(selectInCalendar('a.CellAnchor:contains("13")').parent().parent().attr("bgcolor")).not.to.equal('#DB5141');
                done();
            });
        });
    });
});

mocha.run();

